import { useAuth } from '../../hooks/useAuth';
import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

const CustomerDashboard = () => {
  const { user } = useAuth();
  // const navigate = useNavigate();

  // Redirect if not logged in or wrong role
  // useEffect(() => {
  //   if (!user || user.role !== 'customer') {
  //     navigate('/login'); // redirect to login page
  //   }
  // }, [user, navigate]);

  // if (!user || user.role !== 'customer') return null;

  if(!user) return <p>Loading...</p>;


  return (
    <section className="customer-dashboard" style={{color:'white'}}>
            <h2>Customer Dashboard</h2>
            <h3>Welcome, {user.first_name} {user.last_name}</h3>
            <p>You are a customer</p>
    </section>
  );
};

export default CustomerDashboard;
