From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: compatability with older versions of UEFI
Date: Tue, 23 Jun 2015 10:05:35 -0700
Message-ID: <20150623170534.GA21341@agluck-desk.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

When we print UEFI appendix N error logs provided by plaform
firmware we get to this function:

static void cper_estatus_print_section(
	const char *pfx, const struct acpi_hest_generic_data *gdata, int sec_no)
{

Which includes this code (similar for the other section types):


	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
		printk("%s""section_type: memory error\n", newpfx);
		if (gdata->error_data_length >= sizeof(*mem_err))
			cper_print_mem(newpfx, mem_err);
		else
			goto err_section_too_small;

I'm having a problem with that size check.  The kernel defines
"struct cper_sec_mem_err" according to the 2.3.1 and later versions
of the spec where the last element is the module handle at offset 78
so the "sizeof(*mem_err)" is 80.  But my BIOS defaults to providing
version 2.2 format information, where the last field is the memory
error type, and the struture size is only 73 bytes. So this code
takes the goto err_section_too_small, prints an error message, and
stops decoding.

This is a pity because it looks like the UEFI folk took great care
to make these structures back/forward compatible. Each has a bitfield
at the start saying which elements are valid ... so my 2.2 using BIOS
will never set the valid bits for the fields it doesn't know about.

Perhaps we can have some defines for the size of these structures
in the oldest version of the spec where they exist (2.1 AFAICT):

#define	UEFI_MEMSECTION_MIN_SIZE	73

etc. Then use these as the sanity check?

Or we can be totally distrustful of the BIOS and pass the
"gdata->error_data_length" to the print function and have
it check that size against the offset of any fields that
the validation_bits say we should print.  This feels like
overkill.

-Tony
