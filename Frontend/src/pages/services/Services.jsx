import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { fetchServices } from "../../api/client";
import "../../Style/Services.css";

const Services = () => {
  const [services, setServices] = useState([]);
  const [filteredServices, setFilteredServices] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [searchTerm, setSearchTerm] = useState("");

  useEffect(() => {
    const loadServices = async () => {
      try {
        const res = await fetchServices();
        const servicesList = res.data || [];
        setServices(servicesList);
        setFilteredServices(servicesList);
      } catch (err) {
        console.error("Failed to load services:", err);
        setError("Failed to load services. Please try again later.");
      } finally {
        setLoading(false);
      }
    };
    loadServices();
  }, []);

  useEffect(() => {
    if (!searchTerm.trim()) {
      setFilteredServices(services);
      return;
    }

    const filtered = services.filter(
      (service) =>
        service.title?.toLowerCase().includes(searchTerm.toLowerCase()) ||
        service.description?.toLowerCase().includes(searchTerm.toLowerCase())
    );

    setFilteredServices(filtered);
  }, [searchTerm, services]);

  return (
    <section className="services-page">
        <header className="services-header">
          <h1>Our Services</h1>
          <p className="services-subtitle">
            Find trusted local professionals for any service you need
          </p>
        </header>
        <div className="services-search">
          <input
            type="text"
            placeholder="Search services..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="services-search-input"
            style={{marginTop:'50px'}}
          />
        </div>

      <div className="services-container">

        {loading && <div className="services-loading">Loading services…</div>}
        {error && <div className="services-error">{error}</div>}

        {!loading && !error && (
          <>
            {filteredServices.length === 0 ? (
              <div className="services-empty">
                <h3>No Services Found</h3>
                <p>
                  {searchTerm
                    ? "Try adjusting your search keywords."
                    : "Services will appear here once available."}
                </p>
              </div>
            ) : (
              <div className="services-grid">
                {filteredServices.map((service) => (
                  <Link
                    key={service.id}
                    to={`/services/${service.id}`}
                    className="service-cards"
                  >
                    <div className="service-card-content">
                      <h3>{service.title}</h3>

                      <p className="service-description">
                        {service.description
                          ? `${service.description.substring(0, 120)}${
                              service.description.length > 120 ? "…" : ""
                            }`
                          : "No description available"}
                      </p>

                      <div className="service-footer">
                        <span className="service-price">
                          Rs. {service.price} {" "}
                          {service.price_unit || "service"}
                        </span>
                        <span className="service-link">
                          View Details →
                        </span>
                      </div>
                    </div>
                  </Link>
                ))}
              </div>
            )}
          </>
        )}
      </div>
    </section>
  );
};

export default Services;