package main

import (
	"encoding/csv"
	"fmt"
	"io"
	"log"
	"os"
	"strconv"
	"time"
)

const (
	dateLayout = "2006-01-02 15:04:05"
	column0    = "Date"
	column1    = "Weight (lb)"

	outputDateLayout = "2006-01-02"
)

// Scale data
type Scale struct {
	date   time.Time
	weight float64
}

func main() {
	weights, err := readWithings("weight.csv")
	if err != nil {
		log.Fatal(err)
	}

	for _, w := range weights {
		fmt.Printf("%v %v\n", w.date.Format(outputDateLayout), w.weight)
	}
}

func readWithings(filename string) ([]Scale, error) {
	f, err := os.Open(filename)
	if err != nil {
		return nil, fmt.Errorf("error opening csv file, %w", err)
	}
	defer f.Close()

	r := csv.NewReader(f)

	// read the header record
	header, err := r.Read()
	if err != nil {
		return nil, fmt.Errorf("error reading csv, %w", err)
	}
	if header[0] != column0 {
		return nil, fmt.Errorf("expected csv column 0 to be %v", column0)
	}
	if header[1] != column1 {
		return nil, fmt.Errorf("expected csv column 1 to be %v", column1)
	}

	loc := time.Now().Local().Location()
	weights := make([]Scale, 0, 100)

	for {
		record, err := r.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, fmt.Errorf("error reading csv, %w", err)
		}

		dt, err := time.Parse(dateLayout, record[0])
		if err != nil {
			return nil, fmt.Errorf("error parsing date %q, %w", record[0], err)
		}
		date := time.Date(dt.Year(), dt.Month(), dt.Day(), 0, 0, 0, 0, loc)

		weight, err := strconv.ParseFloat(record[1], 64)
		if err != nil {
			return nil, fmt.Errorf("error parsing weight %q, %w", record[1], err)
		}

		w := Scale{date: date, weight: weight}
		// prepend to array to reverse sort order
		weights = append([]Scale{w}, weights...)
	}

	return weights, nil
}
