From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V8 08/10] ras: acpi / apei: generate trace event for
 unrecognized CPER section
Date: Wed, 15 Feb 2017 10:52:34 -0500
Message-ID: <20170215105234.4921db1f@gandalf.local.home>
References: <1485969413-23577-1-git-send-email-tbaicar@codeaurora.org>
        <1485969413-23577-9-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1485969413-23577-9-git-send-email-tbaicar@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, S
List-Id: linux-efi@vger.kernel.org

On Wed,  1 Feb 2017 10:16:51 -0700
Tyler Baicar <tbaicar@codeaurora.org> wrote:

> @@ -452,11 +454,21 @@ static void ghes_do_proc(struct ghes *ghes,
>  {
>  	int sev, sec_sev;
>  	struct acpi_hest_generic_data *gdata;
> +	uuid_le sec_type;
> +	uuid_le *fru_id = &NULL_UUID_LE;
> +	char *fru_text = "";
>  
>  	sev = ghes_severity(estatus->error_severity);
>  	apei_estatus_for_each_section(estatus, gdata) {
>  		sec_sev = ghes_severity(gdata->error_severity);
> -		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
> +		sec_type = *(uuid_le *)gdata->section_type;
> +
> +		if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
> +			fru_id = (uuid_le *)gdata->fru_id;
> +		if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
> +			fru_text = gdata->fru_text;
> +
> +		if (!uuid_le_cmp(sec_type,
>  				 CPER_SEC_PLATFORM_MEM)) {
>  			struct cper_sec_mem_err *mem_err;
>  
> @@ -467,7 +479,7 @@ static void ghes_do_proc(struct ghes *ghes,
>  			ghes_handle_memory_failure(gdata, sev);
>  		}
>  #ifdef CONFIG_ACPI_APEI_PCIEAER
> -		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
> +		else if (!uuid_le_cmp(sec_type,
>  				      CPER_SEC_PCIE)) {
>  			struct cper_sec_pcie *pcie_err;
>  
> @@ -500,6 +512,12 @@ static void ghes_do_proc(struct ghes *ghes,
>  
>  		}
>  #endif
> +		else {

As an optimization, you can add:

		else if (trace_unknown_sec_event_enabled()) {

instead, as then this wont be called unless the tracepoint is
activated. Will keep the logic from doing anything with
acpi_hest_generic_data_payload().

Note, that trace_*_enabled() is activated via a jump_label, thus
there's no branches involved.

-- Steve

> +			void *unknown_err = acpi_hest_generic_data_payload(gdata);
> +			trace_unknown_sec_event(&sec_type,
> +					fru_id, fru_text, sec_sev,
> +					unknown_err, gdata->error_data_length);
> +		}
>  	}
>  }
>  
>
