from django.utils.translation import gettext_lazy as _

INVALID_PASSWORD = _("Password is incorrect.")

USER_NOT_FOUND = _("No account associated with this email.")
CUSTOMER_NOT_FOUND = _("Customer not found.")
PROVIDER_NOT_FOUND = _("Provider not found.")
DOCUMENT_NOT_FOUND = _("Document not found.")

CUSTOMER_PROFILE_DOES_NOT_EXIST = _("No customer profile associated with this email.")
PROVIDER_PROFILE_DOES_NOT_EXIST = _("No provider profile associated with this email.")

USER_ALREADY_EXISTS = _("User profile already exists for this email.")
CUSTOMER_PROFILE_EXISTS = _("Customer profile already exists for this email.")
PROVIDER_PROFILE_EXISTS = _("Provider profile already exists for this email.")

ADMIN_ACCESS_DENIED = _("No admin privilege for this account.")

INVALID_DOCUMENT_TYPE = _("Document type should be one of these {doc_types}.")

PHONE_NUMBER_ALREADY_ASSOCIATED = _("This phone number is already associated with another account.")
EMAIL_ALREADY_ASSOCIATED = _("This email is already associated with another account.")

DOCUMENT_ASSOCIATED_WITH_ANOTHER_ACC = _("This document number is already associated with another account.")

DOCUMENT_ALREADY_SUBMITTED = _("Document has already been submitted for this provider.")
STATUS_NOT_MATCHED = _("Verification status should be one of these {status}.")