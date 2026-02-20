import RegisterForm from "../../../components/auth/RegisterForm";
import { adminRegister } from "../../../api/client";

const ADMIN_ROLES = [{ id: "admin", label: "Admin" }];

const RegisterAdmin = () => (
    <RegisterForm
        roles={ADMIN_ROLES}
        defaultRole="admin"
        getRegisterApi={() => adminRegister}
        getRedirectPath={() => "/login-admin"}
        loginPath="/login-admin"
        loginLabel="Sign In"
        showRoleSelector={false}
        showNameFields={false}
        showGenderField={false}
    />
);

export default RegisterAdmin;
