package bootsample.dao;

import org.springframework.data.repository.CrudRepository;

import bootsample.model.Book;
import bootsample.model.Reservation;

public interface ReservationRepository extends CrudRepository<Reservation, Integer> {

}
