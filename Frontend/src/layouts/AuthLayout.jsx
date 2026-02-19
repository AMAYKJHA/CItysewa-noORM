import { Outlet } from "react-router-dom";
import "../Style/Layouts.css";

const AuthLayout = () => (
    <main className="auth-layout">
        <Outlet />
    </main>
);
export default AuthLayout;