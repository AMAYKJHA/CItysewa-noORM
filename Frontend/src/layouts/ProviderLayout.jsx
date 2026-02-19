import Navbar from "../components/common/Navbar/NavBar";
import Footer from "../components/common/Footer/Footer";
import { Outlet } from "react-router-dom";
import "./../Style/Layouts.css";

const ProviderLayout = () => {
    return (
        <main className="provider-layout">
            <Navbar type="provider" />
            <section className="provider-main">
                <Outlet />
            </section>
            <Footer type="provider" />
        </main>
    );
};

export default ProviderLayout;
