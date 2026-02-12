"""
IpakYuliBank E-Comm Payment Gateway Client
Based on JSON-RPC 2.0 protocol
API Documentation: https://ecom.ipakyulibank.uz/docs/api/
"""

import httpx
import uuid
import os
from typing import Optional, Dict, Any
from datetime import datetime
from pydantic import BaseModel

# Configuration
IPAKYULI_BASE_URL = os.getenv("IPAKYULI_BASE_URL", "http://partner.ecomm.staging.ipakyulibank.uz")
# Staging API: https://partner.ecomm.staging.ipakyulibank.uz/api/transfer (JSON-RPC 2.0)
IPAKYULI_ACCESS_TOKEN = os.getenv("IPAKYULI_ACCESS_TOKEN", "")
IPAKYULI_CASHBOX_ID = os.getenv("IPAKYULI_CASHBOX_ID", "")
IPAKYULI_MERCHANT_ID = os.getenv("IPAKYULI_MERCHANT_ID", "")

# Success/Fail URLs
SUCCESS_URL = os.getenv("PAYMENT_SUCCESS_URL", "https://yuvgo.uz/")
FAIL_URL = os.getenv("PAYMENT_FAIL_URL", "https://yuvgo.uz/")


class IpakYuliError(Exception):
    """IpakYuliBank API Error"""
    def __init__(self, code: int, message: str):
        self.code = code
        self.message = message
        super().__init__(f"IpakYuli Error {code}: {message}")


class IpakYuliClient:
    """
    IpakYuliBank E-Comm Payment Gateway Client
    
    Supports:
    - Internet acquiring (dynamic payment links)
    - Tokenized payments for subscriptions
    - Payment status checking
    - Payment cancellation
    """
    
    def __init__(self, access_token: str = None, base_url: str = None):
        self.access_token = access_token or IPAKYULI_ACCESS_TOKEN
        self.base_url = base_url or IPAKYULI_BASE_URL
        self.cashbox_id = IPAKYULI_CASHBOX_ID
        
    def _generate_request_id(self) -> str:
        """Generate unique request ID"""
        return str(uuid.uuid4())
    
    async def _make_request(self, endpoint: str, method: str, params: Dict[str, Any]) -> Dict[str, Any]:
        """
        Make JSON-RPC 2.0 request to IpakYuliBank API
        """
        url = f"{self.base_url}/api/{endpoint}"
        
        payload = {
            "jsonrpc": "2.0",
            "id": self._generate_request_id(),
            "method": method,
            "params": params
        }
        
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.access_token}"
        }
        
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.post(url, json=payload, headers=headers)
            data = response.json()
            
            print(f"📡 IpakYuli API Response [{response.status_code}]: {data}")
            
            # Check for JSON-RPC error
            if "error" in data:
                error = data["error"]
                raise IpakYuliError(error.get("code", -1), error.get("message", "Unknown error"))
            
            result = data.get("result", {})
            # Check for result-level error code
            if isinstance(result, dict) and result.get("code") == 1:
                raise IpakYuliError(1, result.get("message", "Request failed"))
            
            return result
    
    # ==================== TRANSFER OPERATIONS ====================
    
    async def create_payment_link(
        self,
        order_id: str,
        amount: int,
        description: str,
        customer_id: Optional[str] = None,
        customer_phone: Optional[str] = None,
        ofd_info: Optional[Dict] = None,
        success_url: str = None,
        fail_url: str = None
    ) -> Dict[str, Any]:
        """
        Create payment link (Internet Acquiring)
        
        This is the recommended method for most cases.
        Customer will be redirected to IpakYuliBank's secure payment page.
        
        Args:
            order_id: Unique order identifier in your system
            amount: Amount in UZS (sums, not tiyin)
            description: Payment description
            customer_id: Optional customer ID for tracking
            customer_phone: Optional customer phone number
            ofd_info: Optional OFD fiscalization data
            success_url: URL to redirect on success
            fail_url: URL to redirect on failure
            
        Returns:
            {
                "transfer_id": "uuid",
                "payment_url": "https://...",
                "status": "await_payment",
                "amount": 5000000,
                "created_at": "2024-01-01T12:00:00Z"
            }
        """
        default_ofd = {
            "Items": [
                {
                    "Name": "YuvGO Subscription",
                    "SPIC": "03304999067000000",
                    "PackageCode": "1344094",
                    "price": amount,
                    "count": 1,
                    "VATPercent": 0,
                    "Discount": 0,
                }
            ]
        }
        params = {
            "order_id": order_id,
            "amount": amount,
            "details": {
                "description": description,
                "ofdInfo": ofd_info or default_ofd,
            },
            "success_url": success_url or SUCCESS_URL,
            "fail_url": fail_url or FAIL_URL
        }
        
        if customer_id:
            params["customer_id"] = customer_id
        if customer_phone:
            params["customer_phone"] = customer_phone
            
        return await self._make_request("transfer", "transfer.create_token", params)
    
    async def get_transfer_status(self, transfer_id: str) -> Dict[str, Any]:
        """
        Get transfer/payment status
        
        Args:
            transfer_id: Transfer UUID from create_payment_link
            
        Returns:
            {
                "transfer_id": "uuid",
                "status": "success|failed|await_payment|in_progress|canceled|expired",
                "amount": 5000000,
                "order_id": "order_123",
                "created_at": "...",
                "updated_at": "..."
            }
        """
        params = {
            "transfer_id": transfer_id
        }
        return await self._make_request("transfer", "transfer.get", params)
    
    async def cancel_transfer(self, transfer_id: str, reason: str = None) -> Dict[str, Any]:
        """
        Cancel a pending transfer
        
        Args:
            transfer_id: Transfer UUID
            reason: Optional cancellation reason
            
        Returns:
            {
                "transfer_id": "uuid",
                "status": "canceled"
            }
        """
        params = {
            "transfer_id": transfer_id
        }
        if reason:
            params["reason"] = reason
            
        return await self._make_request("transfer", "transfer.cancel", params)
    
    # ==================== TOKENIZED PAYMENTS ====================
    
    async def create_tokenization_contract(
        self,
        customer_id: str,
        customer_phone: str,
        description: str = "YuvGO subscription",
        success_url: str = None,
        fail_url: str = None
    ) -> Dict[str, Any]:
        """
        Create tokenization contract for recurring payments
        
        Customer will be redirected to enter card details.
        Card will be tokenized for future automatic payments.
        
        Args:
            customer_id: Unique customer ID in your system
            customer_phone: Customer phone number
            description: Contract description
            success_url: URL to redirect on success
            fail_url: URL to redirect on failure
            
        Returns:
            {
                "contract_id": "uuid",
                "payment_url": "https://...",
                "status": "await_confirmation"
            }
        """
        params = {
            "customer_id": customer_id,
            "customer_phone": customer_phone,
            "description": description,
            "success_url": success_url or SUCCESS_URL,
            "fail_url": fail_url or FAIL_URL
        }
        
        return await self._make_request("tokenized-contract", "tokenized.contract_create", params)
    
    async def pay_with_token(
        self,
        contract_id: str,
        order_id: str,
        amount: int,
        description: str,
        ofd_info: Optional[Dict] = None
    ) -> Dict[str, Any]:
        """
        Make payment using tokenized card
        
        This is used for recurring subscription payments.
        No customer interaction required.
        
        Args:
            contract_id: Tokenization contract ID
            order_id: Unique order ID
            amount: Amount in UZS (sums)
            description: Payment description
            ofd_info: Optional OFD data
            
        Returns:
            {
                "transfer_id": "uuid",
                "status": "success|failed",
                "amount": 5000000
            }
        """
        params = {
            "contract_id": contract_id,
            "order_id": order_id,
            "amount": amount,
            "details": {
                "description": description
            }
        }
        
        if ofd_info:
            params["details"]["ofdInfo"] = ofd_info
            
        return await self._make_request("tokenized-contract", "tokenized.payment_pay", params)
    
    async def list_contracts(self, customer_id: str) -> Dict[str, Any]:
        """
        List all tokenization contracts for a customer
        
        Args:
            customer_id: Customer ID
            
        Returns:
            {
                "contracts": [
                    {
                        "contract_id": "uuid",
                        "card_mask": "8600 **** **** 1234",
                        "card_type": "uzcard",
                        "status": "active",
                        "created_at": "..."
                    }
                ]
            }
        """
        params = {
            "customer_id": customer_id
        }
        return await self._make_request("tokenized-contract", "tokenized.contract_list", params)
    
    async def cancel_contract(self, contract_id: str) -> Dict[str, Any]:
        """
        Cancel/delete a tokenization contract
        
        Args:
            contract_id: Contract ID to cancel
            
        Returns:
            {
                "contract_id": "uuid",
                "status": "canceled"
            }
        """
        params = {
            "contract_id": contract_id
        }
        return await self._make_request("tokenized-contract", "tokenized.contract_cancel", params)
    
    # ==================== STATIC QR ====================
    
    def get_static_qr_url(self, cashbox_id: str = None, lang: str = "uz") -> str:
        """
        Get static QR payment URL for a cashbox
        
        This can be printed and displayed at physical locations.
        
        Args:
            cashbox_id: Cashbox ID (uses default if not provided)
            lang: Language (uz, ru, en)
            
        Returns:
            Static QR payment URL
        """
        cid = cashbox_id or self.cashbox_id
        return f"https://ecom.ipakyulibank.uz/payment/{lang}?type=qr&cashbox={cid}"


# ==================== WEBHOOK MODELS ====================

class IpakYuliWebhookPayload(BaseModel):
    """Webhook payload from IpakYuliBank"""
    transfer_id: str
    order_id: str
    status: str  # success, failed, canceled, expired
    amount: int
    currency: str = "UZS"
    customer_id: Optional[str] = None
    customer_phone: Optional[str] = None
    card_mask: Optional[str] = None
    card_type: Optional[str] = None  # uzcard, humo, visa, mastercard
    created_at: Optional[str] = None
    updated_at: Optional[str] = None
    error_code: Optional[int] = None
    error_message: Optional[str] = None


# ==================== HELPER FUNCTIONS ====================

def amount_to_uzs(amount: float) -> int:
    """Convert amount to integer UZS (API expects amount in sums, not tiyin)"""
    return int(amount)

def amount_to_tiyin(uzs_amount: float) -> int:
    """Convert UZS to tiyin (1 UZS = 100 tiyin) - NOT used for EPOS API"""
    return int(uzs_amount * 100)

def tiyin_to_uzs(tiyin_amount: int) -> float:
    """Convert tiyin to UZS"""
    return tiyin_amount / 100

def get_card_type(card_prefix: str) -> str:
    """Determine card type from prefix"""
    if card_prefix.startswith("8600"):
        return "uzcard"
    elif card_prefix.startswith("9860"):
        return "humo"
    elif card_prefix.startswith("4"):
        return "visa"
    elif card_prefix.startswith("5"):
        return "mastercard"
    return "unknown"


# ==================== TEST CONFIGURATION ====================

# Test OTP code - always use 111111 in test environment
TEST_OTP_CODE = "111111"

# Test expiry date - use any future date like 3309 (September 2033)
TEST_EXPIRY = "3309"

# IMPORTANT: In test mode, use YOUR REAL CARD NUMBER!
# Money will NOT be charged in test environment.
# The test cards below are just format examples.
TEST_CARDS_FORMAT = {
    "uzcard": {
        "prefix": "8600",
        "format": "8600 XXXX XXXX XXXX",
        "expiry": TEST_EXPIRY,
        "otp": TEST_OTP_CODE
    },
    "humo": {
        "prefix": "9860",
        "format": "9860 XXXX XXXX XXXX",
        "expiry": TEST_EXPIRY,
        "otp": TEST_OTP_CODE
    },
    "uzcard_alt": {
        "prefix": "5614",
        "format": "5614 XXXX XXXX XXXX",
        "expiry": TEST_EXPIRY,
        "otp": TEST_OTP_CODE
    }
}

# Transaction statuses
class TransactionStatus:
    AWAIT_PAYMENT = "await_payment"  # Payment link created, waiting for customer
    IN_PROGRESS = "in_progress"      # Customer started payment process
    SUCCESS = "success"              # Payment completed successfully
    FAILED = "failed"                # Payment failed
    CANCELED = "canceled"            # Payment was canceled
    EXPIRED = "expired"              # Payment link expired

# Error codes for cancel operation
class CancelErrorCode:
    SUCCESS = 0           # Successfully canceled
    ALREADY_CANCELED = 1  # Already canceled
    CANNOT_CANCEL = 2     # Cannot cancel (already completed)


# ==================== API ACQUIRING (ONLINE) ====================

class CardData(BaseModel):
    """Card data for API acquiring"""
    number: str  # Card number (8600... or 9860...)
    expire: str  # Expiry date (YYMM format, e.g., 3309)

class ApiAcquiringClient(IpakYuliClient):
    """
    Extended client for API Acquiring (Online) method.
    
    WARNING: This requires PCI DSS certification!
    Use only if your system handles card data directly.
    For most cases, use Internet Acquiring (create_payment_link) instead.
    """
    
    async def create_direct_payment(
        self,
        order_id: str,
        amount: int,
        card_number: str,
        card_expire: str,
        description: str,
        customer_id: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Create payment with card data (API Acquiring)
        
        REQUIRES PCI DSS CERTIFICATION!
        
        Args:
            order_id: Unique order ID
            amount: Amount in tiyin
            card_number: Card number (8600... or 9860...)
            card_expire: Expiry date (YYMM format)
            description: Payment description
            customer_id: Optional customer ID
            
        Returns:
            {
                "transfer_id": "uuid",
                "status": "await_otp",
                "otp_sent_to": "+998*****1234"
            }
        """
        params = {
            "order_id": order_id,
            "amount": amount,
            "card": {
                "number": card_number.replace(" ", ""),
                "expire": card_expire
            },
            "details": {
                "description": description
            }
        }
        
        if customer_id:
            params["customer_id"] = customer_id
            
        return await self._make_request("transfer", "transfer.create", params)
    
    async def confirm_payment(
        self,
        transfer_id: str,
        otp_code: str
    ) -> Dict[str, Any]:
        """
        Confirm payment with OTP code from SMS
        
        Args:
            transfer_id: Transfer ID from create_direct_payment
            otp_code: OTP code from SMS (use 111111 in test mode)
            
        Returns:
            {
                "transfer_id": "uuid",
                "status": "success"
            }
        """
        params = {
            "transfer_id": transfer_id,
            "otp": otp_code
        }
        
        return await self._make_request("transfer", "transfer.confirm", params)


# ==================== OFD FISCALIZATION ====================

class OfdItem(BaseModel):
    """OFD item for fiscalization"""
    name: str           # Product/service name
    price: int          # Price in tiyin
    quantity: int = 1   # Quantity
    vat_percent: int = 0  # VAT percentage (0, 12, 15)
    package_code: Optional[str] = None  # Package code from OFD catalog

class OfdInfo(BaseModel):
    """OFD fiscalization data"""
    items: list  # List of OfdItem
    received_cash: int = 0      # Cash received (tiyin)
    received_card: int = 0      # Card payment (tiyin)
    phone_number: Optional[str] = None  # Customer phone for receipt

def create_ofd_info(
    items: list,
    total_amount: int,
    customer_phone: Optional[str] = None
) -> Dict[str, Any]:
    """
    Create OFD fiscalization data for payment
    
    Args:
        items: List of items with name, price, quantity
        total_amount: Total payment amount in tiyin
        customer_phone: Optional customer phone for receipt
        
    Returns:
        OFD info dict to include in payment details
    """
    ofd_items = []
    for item in items:
        ofd_items.append({
            "Name": item.get("name", "Услуга"),
            "Price": item.get("price", total_amount),
            "Qty": item.get("quantity", 1),
            "VATPercent": item.get("vat_percent", 0),
            "PackageCode": item.get("package_code")
        })
    
    return {
        "items": ofd_items,
        "ReceivedCash": 0,
        "ReceivedCard": total_amount,
        "PhoneNumber": customer_phone
    }


# ==================== WEBHOOK RESPONSE HELPERS ====================

class WebhookResponse:
    """
    Standard webhook response format.
    
    IMPORTANT: Always return {"code": 0} on successful webhook processing,
    otherwise IpakYuliBank will retry the webhook.
    """
    
    @staticmethod
    def success() -> Dict[str, Any]:
        """Return success response - stops webhook retries"""
        return {"code": 0, "message": "OK"}
    
    @staticmethod
    def error(message: str = "Error") -> Dict[str, Any]:
        """Return error response - webhook will be retried"""
        return {"code": 1, "message": message}


class WebhookPayload(BaseModel):
    """
    Webhook payload structure from IpakYuliBank
    
    Fields received in webhook POST request:
    - transactionId: Transfer UUID
    - orderId: Your order ID
    - status: Transaction status (success, failed, canceled, expired)
    - amount: Amount in tiyin
    - sourceAccount: Masked card number (8600****1234)
    """
    transactionId: str
    orderId: str
    status: str
    amount: int
    sourceAccount: Optional[str] = None
    errorCode: Optional[int] = None
    errorMessage: Optional[str] = None


# ==================== BILLING VALIDATION ====================

class BillingValidationClient(IpakYuliClient):
    """
    Client for billing validation (merchant-side validation).
    
    This allows you to validate transactions on your side before
    the payment is processed. Useful for:
    - Checking customer account balance
    - Validating order existence
    - Dynamic amount adjustment
    """
    
    @staticmethod
    def create_validation_response(
        allow: bool,
        amount: Optional[int] = None,
        message: Optional[str] = None,
        additional_data: Optional[Dict] = None
    ) -> Dict[str, Any]:
        """
        Create response for billing validation callback
        
        Args:
            allow: Whether to allow the transaction
            amount: Optional adjusted amount (if different from requested)
            message: Optional message to display to customer
            additional_data: Optional additional data
            
        Returns:
            Response dict for billing validation
        """
        response = {
            "allow": allow
        }
        
        if amount is not None:
            response["amount"] = amount
        if message:
            response["message"] = message
        if additional_data:
            response["data"] = additional_data
            
        return response


# ==================== INTEGRATION CHECKLIST ====================

INTEGRATION_CHECKLIST = """
IpakYuliBank E-Comm Integration Checklist
==========================================

Before going to production, verify:

✅ Payment link creation works (transfer.create_token)
✅ Customers can complete test payments
✅ Webhook notifications are received and processed
✅ Error handling works (invalid card, insufficient funds)
✅ Payment cancellation works (transfer.cancel)
✅ Authorization token is stored securely (not in client code)
✅ All requests use HTTPS
✅ Transaction status checking works (transfer.get)
✅ Correct success_url and fail_url are configured
✅ All API requests/responses are logged
✅ Webhook handling is idempotent (handles duplicates)
✅ Tokenization works for recurring payments (if used)

Test Environment:
- Use YOUR REAL CARD NUMBER (money won't be charged)
- Use expiry date: 3309 (or any future date)
- Use OTP code: 111111

Production:
- Get production credentials from merchant cabinet
- Update IPAKYULI_ACCESS_TOKEN
- Update webhook URL in merchant cabinet
- Test with small real amounts first
"""

def print_integration_checklist():
    """Print integration checklist"""
    print(INTEGRATION_CHECKLIST)
