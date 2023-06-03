import math

def main():
    with open('./day_01.txt') as f:
        fuel_mass = 0
        for line in f.read().split():
           fuel_mass += math.floor(int(line) / 3) - 2 

        # Part One
        print(fuel_mass)

        sum = 0
        sum += fuel_mass
        while fuel_mass > 6:
            fuel_left = math.floor(fuel_mass / 3) - 2 
            sum += fuel_left
            fuel_mass = fuel_left

        print(sum)

main()
