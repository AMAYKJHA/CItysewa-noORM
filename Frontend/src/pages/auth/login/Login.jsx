import LoginForm from "../../../components/auth/LoginForm";
import { customerLogin, providerLogin } from "../../../api/client";

const LOGIN_ROLES = [
    { id: "customer", label: "Customer" },
    { id: "provider", label: "Provider" },
];

const Login = () => (
    <LoginForm
        roles={LOGIN_ROLES}
        defaultRole="customer"
        getLoginApi={(role) => (role === "customer" ? customerLogin : providerLogin)}
        getRedirectPath={(role) => (role === "customer" ? "/customer" : "/provider")}
        registerPath="/register"
        registerLabel="Sign Up"
        showForgotPassword
    />
);

export default Login;