import { useState, useEffect } from 'react';
import { fetchServices } from '../../api/client';
import '../../Style/Home.css';

const FeaturedServices = () => {
  const [services, setServices] = useState([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const getServices = async () => {
      try {
        const response = await fetchServices();
        setServices(response.data?.result?.slice(0, 6) || []);
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    getServices();
  }, []);

  const nextSlide = () => setCurrentIndex((prev) => (prev + 1) % services.length);
  const prevSlide = () => setCurrentIndex((prev) => (prev - 1 + services.length) % services.length);

  if (loading) return <p>Loading services...</p>;
  if (services.length === 0) return <p style={{textAlign:'center'}}>No fetaured services available.</p>;

  const total = services.length;
  const baseAngle = 360 / total; // base rotation per card
  const maxZ = 200; // front card Z distance
  const flattenFactor = 0.7; // smaller = more flat

  return (
    <section className="featured-services">
      <h2>Featured Services</h2>
      <p className="subtitle">Explore our most popular services</p>

      <div className="carousel-container">
        {services.map((service, idx) => {
  let offset = idx - currentIndex;
  const half = Math.floor(total / 2);
  if (offset < -half) offset += total;
  if (offset > half) offset -= total;

  // DYNAMIC UNFOLDING
  const unfoldFactor = 0.5; // 0 = cylinder, 1 = fully flat
  const rotationY = offset * baseAngle * flattenFactor * (1 - unfoldFactor);
  const translateZ = maxZ - Math.abs(offset) * 50 * flattenFactor * (1 - unfoldFactor);

  const scale = offset === 0 ? 1 : 0.7;
  const opacity = offset === 0 ? 1 : 0.3;

  return (
    <div
      key={service.id || idx}
      className={`service-card ${offset === 0 ? 'active' : ''}`}
      style={{
        transform: `translate(-50%, -50%) rotateY(${rotationY}deg) translateZ(${translateZ}px) scale(${scale})`,
        opacity,
        zIndex: offset === 0 ? 2 : 1,
      }}
    >
      <img src={service.thumbnail || '/placeholder.png'} alt={service.title || 'Service'} />
      <div className="service-header">
        <h3>{service.title}</h3>
        <span className="price">Rs. {service.price || 0} {service.price_unit || ''}</span>
      </div>
      <p className="service-desc">{service.description}</p>
      <div className="service-footer">
        <span className="service-category">{service.service_type || 'General'}</span>
      </div>
    </div>
  );
})}

        <div className="carousel-controls">
          <button className="carousel-btn prev" onClick={prevSlide}>❮</button>
          <button className="carousel-btn next" onClick={nextSlide}>❯</button>
        </div>
      </div>
    </section>
  );
};

export default FeaturedServices;

// const FeaturedServices = () => {
// const OPTIONS = { loop: true };
// const SLIDE_COUNT = 6;
// const SLIDES = Array.from(Array(SLIDE_COUNT).keys());
// return(
//   <EmblaCarousel slides={SLIDES} options={OPTIONS} />
// );
// };