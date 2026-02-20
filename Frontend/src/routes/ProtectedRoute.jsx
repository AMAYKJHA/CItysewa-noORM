import { Navigate, Outlet } from "react-router-dom";
import { useAuth } from "../hooks/useAuth";

const ProtectedRoute = ({allowedRoles}) => {
    const { user } = useAuth();

    if(!user || !user.token) {
        const loginPath = allowedRoles?.includes("admin") ? "/login-admin" : "/login";
        return <Navigate to={loginPath} replace />
    }

    if(allowedRoles && !allowedRoles.includes(user.role)) {
        // Redirect to user's own dashboard if they try to access unauthorized route
        const role = user.role?.toLowerCase();
        const dashboardPath = role === "admin" ? "/admin" : role === "provider" ? "/provider" : role === "customer" ? "/customer" : "/";
        return <Navigate to={dashboardPath} replace />
    }

    return <Outlet/>
};

export default ProtectedRoute;