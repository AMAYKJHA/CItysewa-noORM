import LoginForm from "../../../components/auth/LoginForm";
import { adminLogin } from "../../../api/client";

const ADMIN_ROLES = [{ id: "admin", label: "Admin" }];

const LoginAdmin = () => (
    <LoginForm
        roles={ADMIN_ROLES}
        defaultRole="admin"
        getLoginApi={() => adminLogin}
        getRedirectPath={() => "/admin"}
        registerPath="/register-admin"
        registerLabel="Register as Admin"
        showForgotPassword
    />
);

export default LoginAdmin;