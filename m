From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V15 09/11] ras: acpi / apei: generate trace event for
 unrecognized CPER section
Date: Fri, 5 May 2017 14:44:04 -0400
Message-ID: <20170505144404.724da229@gandalf.local.home>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org>
 <1492556723-9189-10-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1492556723-9189-10-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, rafael@kernel.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, nkaje@codeaurora.org, bp@alien8.de, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, tony.luck@intel.com, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju
List-Id: linux-efi@vger.kernel.org


Sorry for the late reply. Borislav pinged me to look at this.


On Tue, 18 Apr 2017 17:05:21 -0600
Tyler Baicar <tbaicar@codeaurora.org> wrote:



> diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
> index 1791a12..5861b6f 100644
> --- a/include/ras/ras_event.h
> +++ b/include/ras/ras_event.h
> @@ -162,6 +162,51 @@
>  );
>  
>  /*
> + * Unknown Section Report
> + *
> + * This event is generated when hardware detected a hardware
> + * error event, which may be of non-standard section as defined
> + * in UEFI spec appendix "Common Platform Error Record", or may
> + * be of sections for which TRACE_EVENT is not defined.
> + *
> + */
> +TRACE_EVENT(unknown_sec_event,
> +
> +	TP_PROTO(const uuid_le *sec_type,
> +		 const uuid_le *fru_id,
> +		 const char *fru_text,
> +		 const u8 sev,
> +		 const u8 *err,
> +		 const u32 len),
> +
> +	TP_ARGS(sec_type, fru_id, fru_text, sev, err, len),
> +
> +	TP_STRUCT__entry(
> +		__array(char, sec_type, 16)
> +		__array(char, fru_id, 16)
> +		__string(fru_text, fru_text)
> +		__field(u8, sev)
> +		__field(u32, len)
> +		__dynamic_array(u8, buf, len)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->sec_type, sec_type, sizeof(uuid_le));
> +		memcpy(__entry->fru_id, fru_id, sizeof(uuid_le));

My only concern here is that you are using sizeof(uuid_le) into an
array that is hardcoded as 16 bytes. I don't expect the size of uuid_le
to ever change, but if it does, you just created an exploit.

I would suggest having a macro about the size of uuid_le and use both
here and include/uapi/linux/uuid.h.

#define UUID_SIZE

typedef struct {
	__u8 b[UUID_SIZE];
} uuid_le;

And then we can just use UUID_SIZE safely here:

	__array(char, sec_type, UUID_SIZE)

[...]

	memcpy(__entry->sec_type, sec_type, UUID_SIZE));

Alternatively we could add in the C file that defines the tracepoints:

BUILD_BUG(sizeof(uuid_le) > 16);

But that's hacky.


> +		__assign_str(fru_text, fru_text);
> +		__entry->sev = sev;
> +		__entry->len = len;
> +		memcpy(__get_dynamic_array(buf), err, len);
> +	),
> +
> +	TP_printk("severity: %d; sec type:%pU; FRU: %pU %s; data len:%d; raw data:%s",
> +		  __entry->sev, __entry->sec_type,

Hmm, I wonder if %pU is defined in the libtraceevent library?

-- Steve

> +		  __entry->fru_id, __get_str(fru_text),
> +		  __entry->len,
> +		  __print_hex(__get_dynamic_array(buf), __entry->len))
> +);
> +
> +/*
>   * PCIe AER Trace event
>   *
>   * These events are generated when hardware detects a corrected or
