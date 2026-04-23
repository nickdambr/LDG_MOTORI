import numpy as np
from scipy.optimize import fsolve

class EquationSystem:
    """
    Base class for defining a system of non-linear equations.
    
    To use this, create a new class that inherits from this one and
    override the `get_equations` method with your specific problem.
    """
    def __init__(self, variable_names):
        """
        Initializes the equation system.
        
        Args:
            variable_names (list of str): The names of the variables to be solved for.
        """
        if not isinstance(variable_names, list):
            raise TypeError("variable_names must be a list of strings.")
        self.variable_names = variable_names
        self.params = {}

    def define_parameters(self, **params):
        """Stores the fixed parameters for the current calculation."""
        self.params = params

    def get_equations(self, var_values):
        """
        Defines the system of equations. This method MUST be overridden by a child class.
        
        It should return a list or array of equation residuals (i.e., f(x) = 0).
        
        Args:
            var_values (list or np.array): A list containing the current values of the
                                          variables being solved for, in the same order
                                          as `self.variable_names`.
        
        Returns:
            list or np.array: A list of the results of each equation (the residuals).
        """
        raise NotImplementedError("You must override the 'get_equations' method in your custom class.")

class Solver:
    """
    A generic solver for a system of non-linear equations defined by an EquationSystem object.
    """
    def __init__(self, equation_system):
        """
        Initializes the solver.
        
        Args:
            equation_system (EquationSystem): An instance of a class that inherits from EquationSystem.
        """
        if not isinstance(equation_system, EquationSystem):
            raise TypeError("equation_system must be an instance of a class derived from EquationSystem.")
        self.system = equation_system

    def solve(self, initial_guess, **params):
        """
        Solves the system for a given set of parameters.
        
        Args:
            initial_guess (list or np.array): An initial guess for the variables.
            **params: Keyword arguments for all parameters required by the equations.
            
        Returns:
            dict: A dictionary mapping variable names to their solved values.
        """
        # 1. Define the parameters for the system
        self.system.define_parameters(**params)
        
        # 2. Create the function that fsolve will use
        # This function takes the variable values and returns the equation residuals.
        func_to_solve = lambda var_values: self.system.get_equations(var_values)
        
        # 3. Use scipy's fsolve to find the root
        solution_vector, _, exit_flag, msg = fsolve(func_to_solve, initial_guess, full_output=True)
        
        if exit_flag != 1:
            print(f"Warning: Solver did not converge. Message: {msg}")
            # Return a dictionary of NaNs on failure
            return {name: np.nan for name in self.system.variable_names}
            
        # 4. Return the solution as a user-friendly dictionary
        return dict(zip(self.system.variable_names, solution_vector))



