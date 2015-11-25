function testEncounterPoint()
        test1Value = rand()
        #################################################################
        ############### TESTE 1 #########################################
        first = LinearFunc(test1Value,test1Value,test1Value,test1Value)
        second = LinearFunc(test1Value,test1Value,test1Value,test1Value)
        solution::FastSolution = solveFast(first,second)
        if(!solution.hasSolution)
            print("test 1: hasSolution should be true\n")
        elseif(solution.blockVision)
            print("test 1: blockVision should be false\n")
        else
            print("test 1: OK\n")
        end

        #################################################################
        ############### END TESTE 1 #########################################


        #################################################################
        ############### TESTE 2 #########################################

       second = LinearFunc(test1Value+1,test1Value+1,test1Value+1,test1Value+1)
       solution = solveFast(first,second)
       if(solution.hasSolution)
           print("test 2: hasSolution should be false\n")
       elseif(solution.blockVision)
           print("test 2: blockVision should be false\n")
       else
           print("test 2: OK\n")
       end

       #################################################################
       ############### END TESTE 2 #########################################


      #################################################################
      ############### TESTE 3 #########################################
      second = first
      first = LinearFunc(test1Value+1,test1Value+1,test1Value+1,test1Value+1)
      solution = solveFast(first,second)
      if(solution.hasSolution)
          print("test 3: hasSolution should be false\n")
      elseif(solution.blockVision)
          print("test 3: blockVision should be false\n")
      else
          print("test 3: OK\n")
      end

      #################################################################
      ############### END TESTE 3 #########################################

      #################################################################
      ############### TESTE 4 #########################################
      second = LinearFunc(test1Value,test1Value,test1Value,test1Value)
      first = LinearFunc(test1Value+1,test1Value+1,test1Value-1,test1Value-1)
      solution = solveFast(first,second)
      if(!solution.hasSolution)
          print("test 4: hasSolution should be true\n")
      elseif(!solution.blockVision)
          print("test 4: blockVision should be true\n")
      else
          print("test 4: OK\n")
      end

      #################################################################
      ############### END TESTE 4 #########################################


      #################################################################
      ############### TESTE 5 #########################################
      solution = solveFast(second,first)
      if(!solution.hasSolution)
          print("test 5: hasSolution should be true\n")
      elseif(!solution.blockVision)
          print("test 5: blockVision should be true\n")
      else
          print("test 5: OK\n")
      end

      #################################################################
      ############### END TESTE 5 #########################################


    #################################################################
    ############### TESTE 6 #########################################
    second = LinearFunc(test1Value+1,test1Value,test1Value+1,test1Value)
    first = LinearFunc(test1Value+1,test1Value+1,test1Value-1,test1Value-1)
    solution = solveFast(first,second)
    if(solution.hasSolution)
        print("test 6: hasSolution should be false\n")
    elseif(solution.blockVision)
        print("test 6: blockVision should be false\n")
    else
        print("test 6: OK\n")
    end

    #################################################################
    ############### END TESTE 6 #########################################


    #################################################################
    ############### TESTE 7 #########################################
    solution = solveFast(second,first)
    if(solution.hasSolution)
        print("test 7: hasSolution should be false\n")
    elseif(solution.blockVision)
        print("test 7: blockVision should be false\n")
    else
        print("test 7: OK\n")
    end

    #################################################################
    ############### END TESTE 7 #########################################


    #################################################################
    ############### TESTE 8 #########################################
    test1Value = rand()*18
    second = LinearFunc(test1Value+2.0,test1Value+0.0,test1Value+18.0,test1Value+0.0)
    first = LinearFunc(test1Value+0.0,test1Value+2.0,test1Value+0.0,test1Value+18.0)
    solution = solveFast(first,second)
    if(!solution.hasSolution)
        print("test 8: hasSolution should be true\n")
    elseif(solution.blockVision)
        print("test 8: blockVision should be false\n")
    else
        print("test 8: OK\n")
    end

    #################################################################
    ############### END TESTE 8 #########################################


    #################################################################
    ############### TESTE 9 #########################################
    solution = solveFast(second,first)
    if(!solution.hasSolution)
        print("test 9: hasSolution should be true\n")
    elseif(solution.blockVision)
        print("test 9: blockVision should be false\n")
    else
        print("test 9: OK\n")
    end

    #################################################################
    ############### END TESTE 9 #########################################



    #################################################################
    ############### TESTE 10 #########################################

    second = LinearFunc(test1Value-2.0,test1Value+0.0,test1Value+18.0,test1Value+0.0)
    first = LinearFunc(test1Value+0.0,test1Value+-2.0,test1Value+0.0,test1Value+18.0)
    solution = solveFast(first,second)
    if(!solution.hasSolution)
        print("test 10: hasSolution should be true\n")
    elseif(!solution.blockVision)
        print("test 10: blockVision should be true\n")
    else
        print("test 10: OK\n")
    end

    #################################################################
    ############### END TESTE 10 #########################################


    #################################################################
    ############### TESTE 11 #########################################
    solution = solveFast(second,first)
    if(!solution.hasSolution)
        print("test 11: hasSolution should be true\n")
    elseif(!solution.blockVision)
        print("test 11: blockVision should be true\n")
    else
        print("test 11: OK\n")
    end

    #################################################################
    ############### END TESTE 11 #########################################


    #################################################################
    ############### TESTE 12 #########################################

    second = LinearFunc(test1Value+2.0,test1Value+0.0,test1Value+18.0,test1Value+1.0)
    first = LinearFunc(test1Value+0.0,test1Value+-2.0,test1Value+0.0,test1Value+18.0)
    solution = solveFast(first,second)
    if(!solution.hasSolution)
        print("test 12: hasSolution should be true\n")
    elseif(solution.blockVision)
        print("test 12: blockVision should be false\n")
    else
        print("test 12: OK\n")
    end

    #################################################################
    ############### END TESTE 12 #########################################


    #################################################################
    ############### TESTE 13 #########################################

    solution = solveFast(second,first)
    if(!solution.hasSolution)
        print("test 13: hasSolution should be true\n")
    elseif(solution.blockVision)
        print("test 13: blockVision should be false\n")
    else
        print("test 13: OK\n")
    end

    #################################################################
    ############### END TESTE 13 #########################################


    #################################################################
    ############### TESTE 14 #########################################

    second = LinearFunc(test1Value-2.0,test1Value+0.0,test1Value+18.0,test1Value+1.0)
    first = LinearFunc(test1Value+0.0,test1Value+-2.0,test1Value+0.0,test1Value+18.0)
    solution = solveFast(first,second)
    if(!solution.hasSolution)
        print("test 14: hasSolution should be true\n")
    elseif(!solution.blockVision)
        print("test 14: blockVision should be true\n")
    else
        print("test 14: OK\n")
    end

    #################################################################
    ############### END TESTE 14 #########################################


    #################################################################
    ############### TESTE 15 #########################################
    solution = solveFast(second,first)
    if(!solution.hasSolution)
        print("test 15: hasSolution should be true\n")
    elseif(!solution.blockVision)
        print("test 15: blockVision should be true\n")
    else
        print("test 15: OK\n")
    end

    #################################################################
    ############### END TESTE 15 #########################################


    #################################################################
    ############### TESTE 16 #########################################
    test1Value = rand()*18
    second = LinearFunc(test1Value+2.0,test1Value+0.0,test1Value+18.0,test1Value+0.0)
    first = LinearFunc(test1Value+0.0,test1Value+2.0,test1Value+1.0,test1Value+18.0)
    solution = solveFast(first,second)
    if(!solution.hasSolution)
        print("test 16: hasSolution should be true\n")
    elseif(solution.blockVision)
        print("test 16: blockVision should be false\n")
    else
        print("test 16: OK\n")
    end

    #################################################################
    ############### END TESTE 16 #########################################


    #################################################################
    ############### TESTE 17 #########################################
    solution = solveFast(second,first)
    if(!solution.hasSolution)
        print("test 17: hasSolution should be true\n")
    elseif(solution.blockVision)
        print("test 17: blockVision should be false\n")
    else
        print("test 17: OK\n")
    end

    #################################################################
    ############### END TESTE 17 #########################################



    #################################################################
    ############### TESTE 18 #########################################

    second = LinearFunc(test1Value-2.0,test1Value+0.0,test1Value+18.0,test1Value+0.0)
    first = LinearFunc(test1Value+0.0,test1Value+-2.0,test1Value+1.0,test1Value+18.0)
    solution = solveFast(first,second)
    if(!solution.hasSolution)
        print("test 18: hasSolution should be true\n")
    elseif(!solution.blockVision)
        print("test 18: blockVision should be true\n")
    else
        print("test 18: OK\n")
    end

    #################################################################
    ############### END TESTE 18 #########################################


    #################################################################
    ############### TESTE 19 #########################################

    solution = solveFast(second,first)
    if(!solution.hasSolution)
        print("test 19: hasSolution should be true\n")
    elseif(!solution.blockVision)
        print("test 19: blockVision should be true\n")
    else
        print("test 19: OK\n")
    end

    #################################################################
    ############### END TESTE 19 #########################################


    #################################################################
    ############### TESTE 20 #########################################
    test1Value = rand()*18
    second = LinearFunc(test1Value+2.0,test1Value+0.0,test1Value+18.0,test1Value+3.0)
    first = LinearFunc(test1Value+0.0,test1Value+2.0,test1Value+1.0,test1Value+18.0)
    solution = solveFast(first,second)
    if(!solution.hasSolution)
        print("test 20: hasSolution should be true\n")
    elseif(solution.blockVision)
        print("test 20: blockVision should be false\n")
    else
        print("test 20: OK\n")
    end

    #################################################################
    ############### END TESTE 20 #########################################


    #################################################################
    ############### TESTE 21 #########################################
    solution = solveFast(second,first)
    if(!solution.hasSolution)
        print("test 21: hasSolution should be true\n")
    elseif(solution.blockVision)
        print("test 21: blockVision should be false\n")
    else
        print("test 21: OK\n")
    end

    #################################################################
    ############### END TESTE 21 #########################################

    #################################################################
    ############### TESTE 22 #########################################

    second = LinearFunc(test1Value-2.0,test1Value+0.0,test1Value+18.0,test1Value+4.0)
    first = LinearFunc(test1Value+0.0,test1Value+-2.0,test1Value+1.0,test1Value+18.0)
    solution = solveFast(first,second)
    if(!solution.hasSolution)
        print("test 22: hasSolution should be true\n")
    elseif(!solution.blockVision)
        print("test 22: blockVision should be true\n")
    else
        print("test 22: OK\n")
    end

    #################################################################
    ############### END TESTE 22 #########################################


    #################################################################
    ############### TESTE 23 #########################################
    solution = solveFast(second,first)
    if(!solution.hasSolution)
        print("test 23: hasSolution should be true\n")
    elseif(!solution.blockVision)
        print("test 23: blockVision should be true\n")
    else
        print("test 23: OK\n")
    end

    #################################################################
    ############### END TESTE 23 #########################################


end
