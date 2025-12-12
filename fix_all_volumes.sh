#!/bin/bash
# Remove all backend service volume mounts from docker-compose.yml

sed -i.backup2 '
/user_service:/,/^  [a-z]/ {
    /volumes:/,/networks:/ {
        /volumes:/s/^/    # /
        /- \.\/backend\/services/s/^/    # /
    }
}
/subscription_service:/,/^  [a-z]/ {
    /volumes:/,/networks:/ {
        /volumes:/s/^/    # /
        /- \.\/backend\/services/s/^/    # /
    }
}
/partner_service:/,/^  [a-z]/ {
    /volumes:/,/networks:/ {
        /volumes:/s/^/    # /
        /- \.\/backend\/services/s/^/    # /
    }
}
/visit_service:/,/^  [a-z]/ {
    /volumes:/,/networks:/ {
        /volumes:/s/^/    # /
        /- \.\/backend\/services/s/^/    # /
    }
}
/payment_service:/,/^  [a-z]/ {
    /volumes:/,/networks:/ {
        /volumes:/s/^/    # /
        /- \.\/backend\/services/s/^/    # /
    }
}
/notification_service:/,/^  [a-z]/ {
    /volumes:/,/networks:/ {
        /volumes:/s/^/    # /
        /- \.\/backend\/services/s/^/    # /
    }
}
/admin_service:/,/^  [a-z]/ {
    /volumes:/,/networks:/ {
        /volumes:/s/^/    # /
        /- \.\/backend\/services/s/^/    # /
    }
}
' docker-compose.yml

echo "Fixed all backend service volume mounts"
