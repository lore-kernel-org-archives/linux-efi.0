From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V2 2/2] ras: acpi / apei: generate trace event for
 unrecognized CPER section
Date: Thu, 10 Sep 2015 20:41:36 +0200
Message-ID: <20150910184136.GC10457@pd.tnic>
References: <1441747761-12012-1-git-send-email-zjzhang@codeaurora.org>
 <1441747761-12012-3-git-send-email-zjzhang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1441747761-12012-3-git-send-email-zjzhang@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Cc: Matt Fleming <matt.fleming@intel.com>, tony.luck@intel.com, fu.wei@linaro.org, al.stone@linaro.org, rjw@rjwysocki.net, mchehab@osg.samsung.com, mingo@redhat.com, gong.chen@linux.intel.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org, vgandhi@codeaurora.org, linux-acpi@vger.kernel.org, timur@codeaurora.org
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 08, 2015 at 02:29:21PM -0700, Jonathan (Zhixiong) Zhang wrote:
>  /*
> + * Raw Events Report
> + *
> + * This event is generated when hardware detected a hardware
> + * error event, which may be of non-standard section as defined
> + * in UEFI spec appendix "Common Platform Error Record", or may
> + * be of sections for which TRACE_EVENT is not defined.
> + *
> + */
> +TRACE_EVENT(raw_event,
> +
> +	TP_PROTO(const uuid_le *sec_type,
> +		 const uuid_le *fru_id,
> +		 const char *fru_text,
> +		 u8 sev,
> +		 const u8 *err,
> +		 const u32 len),

This is not a raw event - this is an event which has a section type, FRU
ID, text, etc, etc.

A raw event is one which takes exactly two arguments: bytes and count.
What it does is, it dumps the bytes of length count in a block or other
amicably formatted output, most likely hex, similar to hexdump or other
tools; *without* any attempt to interpret it whatsoever.

Its *consumers* do the interpretation. So that that raw_event tracepoint
can be used as a fallback in all cases where the error information is of
unknown structure to the kernel.

Btw, @count should be sanity-checked before calling the tracepoint with
insane values.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
