function testVisiblePerf(obstacles,pedestrians)
    number = 10^6
    eyes = rand(number,2)
    points = rand(number,2)
    eye = eyes[1,:]
    point = points[1,:]
    tic()
    for ped1 = pedestrians
        for ped2 = pedestrians
            if(ped1 != ped2)
                isVisible(ped1.position,obstacles,ped2.position)
                #if  #!= isVisibleOld(ped1.position,obstacles,ped2.position)
                #    print("falhaaaa")
                #    return true
                #end
            end
        end;
    end
    toc()
end
