import { Outlet } from "react-router-dom";
import Navbar from "../components/common/Navbar/NavBar";
import Footer from "../components/common/Footer/Footer";
import "./../Style/Layouts.css";

const CustomerLayout = () => {
    return (
        <main className="customer-layout">
            <Navbar type="customer" />
            <section className="customer-main">
                <Outlet />
            </section>
            <Footer type="customer" />
        </main>
    );
};

export default CustomerLayout;
