global class EmailVerificationService {

	public class Is_valid_format {
		public Boolean value;
		public String text;
	}

	public String email;
	public String autocorrect;
	public String deliverability;
	public String quality_score;
	public Is_valid_format is_valid_format;
	public Is_valid_format is_free_email;
	public Is_valid_format is_disposable_email;
	public Is_valid_format is_role_email;
	public Is_valid_format is_catchall_email;
	public Is_valid_format is_mx_found;
	public Is_valid_format is_smtp_valid;

	
	public static EmailVerificationService parse(String json) {
		return (EmailVerificationService) System.JSON.deserialize(json, EmailVerificationService.class);
	}
}