const LinearFunc = LinearFunc2D  # shorthand alias used by tests

function testEncounterPoint()
        test1Value = rand()
        #################################################################
        ############### TESTE 1 #########################################
        first = LinearFunc(test1Value,test1Value,test1Value,test1Value)
        second = LinearFunc(test1Value,test1Value,test1Value,test1Value)
        solution = solveFast(first,second)
        if(!solution.hasSolution)
            println("test 1: hasSolution should be true")
        elseif(solution.blockVision)
            println("test 1: blockVision should be false")
        else
            println("test 1: OK")
        end

        #################################################################
        ############### END TESTE 1 #########################################


        #################################################################
        ############### TESTE 2 #########################################

       second = LinearFunc(test1Value+1,test1Value+1,test1Value+1,test1Value+1)
       solution = solveFast(first,second)
       if(solution.hasSolution)
           println("test 2: hasSolution should be false")
       elseif(solution.blockVision)
           println("test 2: blockVision should be false")
       else
           println("test 2: OK")
       end

       #################################################################
       ############### END TESTE 2 #########################################


      #################################################################
      ############### TESTE 3 #########################################
      second = first
      first = LinearFunc(test1Value+1,test1Value+1,test1Value+1,test1Value+1)
      solution = solveFast(first,second)
      if(solution.hasSolution)
          println("test 3: hasSolution should be false")
      elseif(solution.blockVision)
          println("test 3: blockVision should be false")
      else
          println("test 3: OK")
      end

      #################################################################
      ############### END TESTE 3 #########################################

      #################################################################
      ############### TESTE 4 #########################################
      second = LinearFunc(test1Value,test1Value,test1Value,test1Value)
      first = LinearFunc(test1Value+1,test1Value+1,test1Value-1,test1Value-1)
      solution = solveFast(first,second)
      if(!solution.hasSolution)
          println("test 4: hasSolution should be true")
      elseif(!solution.blockVision)
          println("test 4: blockVision should be true")
      else
          println("test 4: OK")
      end

      #################################################################
      ############### END TESTE 4 #########################################


      #################################################################
      ############### TESTE 5 #########################################
      solution = solveFast(second,first)
      if(!solution.hasSolution)
          println("test 5: hasSolution should be true")
      elseif(!solution.blockVision)
          println("test 5: blockVision should be true")
      else
          println("test 5: OK")
      end

      #################################################################
      ############### END TESTE 5 #########################################


    #################################################################
    ############### TESTE 6 #########################################
    second = LinearFunc(test1Value+1,test1Value,test1Value+1,test1Value)
    first = LinearFunc(test1Value+1,test1Value+1,test1Value-1,test1Value-1)
    solution = solveFast(first,second)
    if(solution.hasSolution)
        println("test 6: hasSolution should be false")
    elseif(solution.blockVision)
        println("test 6: blockVision should be false")
    else
        println("test 6: OK")
    end

    #################################################################
    ############### END TESTE 6 #########################################


    #################################################################
    ############### TESTE 7 #########################################
    solution = solveFast(second,first)
    if(solution.hasSolution)
        println("test 7: hasSolution should be false")
    elseif(solution.blockVision)
        println("test 7: blockVision should be false")
    else
        println("test 7: OK")
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
        println("test 8: hasSolution should be true")
    elseif(solution.blockVision)
        println("test 8: blockVision should be false")
    else
        println("test 8: OK")
    end

    #################################################################
    ############### END TESTE 8 #########################################


    #################################################################
    ############### TESTE 9 #########################################
    solution = solveFast(second,first)
    if(!solution.hasSolution)
        println("test 9: hasSolution should be true")
    elseif(solution.blockVision)
        println("test 9: blockVision should be false")
    else
        println("test 9: OK")
    end

    #################################################################
    ############### END TESTE 9 #########################################



    #################################################################
    ############### TESTE 10 #########################################

    second = LinearFunc(test1Value-2.0,test1Value+0.0,test1Value+18.0,test1Value+0.0)
    first = LinearFunc(test1Value+0.0,test1Value+-2.0,test1Value+0.0,test1Value+18.0)
    solution = solveFast(first,second)
    if(!solution.hasSolution)
        println("test 10: hasSolution should be true")
    elseif(!solution.blockVision)
        println("test 10: blockVision should be true")
    else
        println("test 10: OK")
    end

    #################################################################
    ############### END TESTE 10 #########################################


    #################################################################
    ############### TESTE 11 #########################################
    solution = solveFast(second,first)
    if(!solution.hasSolution)
        println("test 11: hasSolution should be true")
    elseif(!solution.blockVision)
        println("test 11: blockVision should be true")
    else
        println("test 11: OK")
    end

    #################################################################
    ############### END TESTE 11 #########################################


    #################################################################
    ############### TESTE 12 #########################################

    second = LinearFunc(test1Value+2.0,test1Value+0.0,test1Value+18.0,test1Value+1.0)
    first = LinearFunc(test1Value+0.0,test1Value+-2.0,test1Value+0.0,test1Value+18.0)
    solution = solveFast(first,second)
    if(!solution.hasSolution)
        println("test 12: hasSolution should be true")
    elseif(solution.blockVision)
        println("test 12: blockVision should be false")
    else
        println("test 12: OK")
    end

    #################################################################
    ############### END TESTE 12 #########################################


    #################################################################
    ############### TESTE 13 #########################################

    solution = solveFast(second,first)
    if(!solution.hasSolution)
        println("test 13: hasSolution should be true")
    elseif(solution.blockVision)
        println("test 13: blockVision should be false")
    else
        println("test 13: OK")
    end

    #################################################################
    ############### END TESTE 13 #########################################


    #################################################################
    ############### TESTE 14 #########################################

    second = LinearFunc(test1Value-2.0,test1Value+0.0,test1Value+18.0,test1Value+1.0)
    first = LinearFunc(test1Value+0.0,test1Value+-2.0,test1Value+0.0,test1Value+18.0)
    solution = solveFast(first,second)
    if(!solution.hasSolution)
        println("test 14: hasSolution should be true")
    elseif(!solution.blockVision)
        println("test 14: blockVision should be true")
    else
        println("test 14: OK")
    end

    #################################################################
    ############### END TESTE 14 #########################################


    #################################################################
    ############### TESTE 15 #########################################
    solution = solveFast(second,first)
    if(!solution.hasSolution)
        println("test 15: hasSolution should be true")
    elseif(!solution.blockVision)
        println("test 15: blockVision should be true")
    else
        println("test 15: OK")
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
        println("test 16: hasSolution should be true")
    elseif(solution.blockVision)
        println("test 16: blockVision should be false")
    else
        println("test 16: OK")
    end

    #################################################################
    ############### END TESTE 16 #########################################


    #################################################################
    ############### TESTE 17 #########################################
    solution = solveFast(second,first)
    if(!solution.hasSolution)
        println("test 17: hasSolution should be true")
    elseif(solution.blockVision)
        println("test 17: blockVision should be false")
    else
        println("test 17: OK")
    end

    #################################################################
    ############### END TESTE 17 #########################################



    #################################################################
    ############### TESTE 18 #########################################

    second = LinearFunc(test1Value-2.0,test1Value+0.0,test1Value+18.0,test1Value+0.0)
    first = LinearFunc(test1Value+0.0,test1Value+-2.0,test1Value+1.0,test1Value+18.0)
    solution = solveFast(first,second)
    if(!solution.hasSolution)
        println("test 18: hasSolution should be true")
    elseif(!solution.blockVision)
        println("test 18: blockVision should be true")
    else
        println("test 18: OK")
    end

    #################################################################
    ############### END TESTE 18 #########################################


    #################################################################
    ############### TESTE 19 #########################################

    solution = solveFast(second,first)
    if(!solution.hasSolution)
        println("test 19: hasSolution should be true")
    elseif(!solution.blockVision)
        println("test 19: blockVision should be true")
    else
        println("test 19: OK")
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
        println("test 20: hasSolution should be true")
    elseif(solution.blockVision)
        println("test 20: blockVision should be false")
    else
        println("test 20: OK")
    end

    #################################################################
    ############### END TESTE 20 #########################################


    #################################################################
    ############### TESTE 21 #########################################
    solution = solveFast(second,first)
    if(!solution.hasSolution)
        println("test 21: hasSolution should be true")
    elseif(solution.blockVision)
        println("test 21: blockVision should be false")
    else
        println("test 21: OK")
    end

    #################################################################
    ############### END TESTE 21 #########################################

    #################################################################
    ############### TESTE 22 #########################################

    second = LinearFunc(test1Value-2.0,test1Value+0.0,test1Value+18.0,test1Value+4.0)
    first = LinearFunc(test1Value+0.0,test1Value+-2.0,test1Value+1.0,test1Value+18.0)
    solution = solveFast(first,second)
    if(!solution.hasSolution)
        println("test 22: hasSolution should be true")
    elseif(!solution.blockVision)
        println("test 22: blockVision should be true")
    else
        println("test 22: OK")
    end

    #################################################################
    ############### END TESTE 22 #########################################


    #################################################################
    ############### TESTE 23 #########################################
    solution = solveFast(second,first)
    if(!solution.hasSolution)
        println("test 23: hasSolution should be true")
    elseif(!solution.blockVision)
        println("test 23: blockVision should be true")
    else
        println("test 23: OK")
    end

    #################################################################
    ############### END TESTE 23 #########################################


end
