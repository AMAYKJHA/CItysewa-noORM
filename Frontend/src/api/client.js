import axios from 'axios';

// Base axios instance
const api = axios.create({
    baseURL: 'https://citysewa2.onrender.com/api/v1', //Backend url
});

api.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem("token");
        const isAuthRoute = config.url?.includes("/login") || config.url?.includes("/register");
        if(token && !isAuthRoute){
            config.headers = config.headers || {};
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => Promise.reject(error)
);

api.interceptors.response.use(
    (response) => response,
    (error) => {
        if(error.response?.status === 401) {
            const user = JSON.parse(localStorage.getItem("user") || "null");
            const isAdmin = user?.role === "admin";
            localStorage.removeItem("token");
            localStorage.removeItem("user");
            window.location.href = isAdmin ? "/login-admin" : "/login";
        }
        return Promise.reject(error);
    }
);

/* Accounts */

//Customer registration info post and login
export const customerLogin = (data) =>
    api.post("/accounts/customer/login",data);

export const customerRegister = (data) => 
    api.post("/accounts/customer/register",data);

//Customer info fetch
export const fetchCustomers = () => 
    api.get("/accounts/customer");

export const fetchCustomerById = (id) => 
    api.get(`/accounts/customer/${id}`);

//Provider registration info post and login
export const providerLogin = (data) =>
    api.post("/accounts/provider/login",data);

export const providerRegister = (data) => 
    api.post("/accounts/provider/register",data);

//Provider info fetch
export const fetchProviders = () => 
    api.get("/accounts/provider");

export const fetchProviderById = (id) => 
    api.get(`/accounts/provider/${id}`);

//Provider verification
export const submitForVerification = (data) =>
    api.post("/accounts/provider/submit-verification",data,{
        headers: {
            "Content-Type": "multipart/form-data",
        }
    });

//Provider verification in Admin side
export const fetchVerificationData = () => 
    api.get("/accounts/provider/verification-data");

export const fetchVerificationDataById = (id) =>
    api.get(`/accounts/provider/verification-data/${id}`);

export const updateVerificationData = (id, data) => 
    api.patch(`/accounts/provider/verification-data/${id}`,data);

//Admin login/register
export const adminLogin = (data) => 
    api.post("/accounts/admin/login",data);

export const adminRegister = (data) =>
    api.post("/accounts/admin/register",data);

//Service related APIs
export const fetchServices = () =>
    api.get("/services");

export const fetchServiceById = (id) =>
    api.get(`/services/${id}`);

export const createService = (data) =>
    api.post("/services/register",data);

//Booking related APIs
export const fetchBookings = (data) =>
    api.get("/bookings",data);

export const fetchCustomerBookings = (id) =>
    // api.get(`/bookings/${id}`);
    api.get(`bookings?customer_id=${id}`);

export const fetchProviderBookings = (id) =>
    api.get(`bookings?provider_id=${id}`);

export const createBooking = (data) =>
    api.post("/bookings/register",data);

export const getBookingStats = () =>
    api.get("/bookings/stats");

//Address related APIs
export const fetchAddresses = () =>
    api.get("/addresses");

export default api;