from src.logger import get_logger
from src.custom_exception import CustomException
import sys

logger = get_logger(__name__)

def divide_numbers(num1, num2):
    try:
        result = num1 / num2
        logger.info(f"Division successful: {num1} / {num2} = {result}")
        return result
    except Exception as e:
        logger.error("An error occurred during division.")
        raise CustomException("Division by zero is not allowed.", sys)
    
if __name__ == "__main__":
    try:
        logger.info("Starting division operation.")
        divide_numbers(10, 0)
    except CustomException as ce:
        logger.error(str(ce))