function testVisiblePerf(obstacles, pedestrians)
    number = 10^6
    eyes = rand(number, 2)
    points = rand(number, 2)
    eye = eyes[1, :]
    point = points[1, :]
    elapsed = @elapsed begin
        for ped1 in pedestrians
            for ped2 in pedestrians
                if ped1 != ped2
                    isVisible(ped1.position, obstacles, ped2.position)
                end
            end
        end
    end
    println("Elapsed time: ", elapsed, " seconds")
end
