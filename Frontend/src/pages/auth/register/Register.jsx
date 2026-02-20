import RegisterForm from "../../../components/auth/RegisterForm";
import { customerRegister, providerRegister } from "../../../api/client";

const REGISTER_ROLES = [
    { id: "customer", label: "Customer" },
    { id: "provider", label: "Provider" },
];

const Register = () => (
    <RegisterForm
        roles={REGISTER_ROLES}
        defaultRole="customer"
        getRegisterApi={(role) => {
            const roleLower = role.toLowerCase();
            if (roleLower === "provider") return providerRegister;
            return customerRegister;
        }}
        getRedirectPath={(role) => "/login"}
        loginPath="/login"
        loginLabel="Sign In"
        showRoleSelector
        showNameFields
        showGenderField
    />
);

export default Register;
