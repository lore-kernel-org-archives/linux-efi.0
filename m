From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH V3 02/10] ras: acpi/apei: cper: generic error data entry
 v3 per ACPI 6.1
Date: Tue, 11 Oct 2016 19:52:36 +0100
Message-ID: <20161011185236.GC1041@n2100.armlinux.org.uk>
References: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
 <1475875882-2604-3-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1475875882-2604-3-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: mark.rutland@arm.com, linux-efi@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, Richard Ruigrok <rruigrok@codeaurora.org>, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, robert.moore@intel.com, linux-acpi@vger.kernel.org, shijie.huang@arm.com, lenb@kernel.org, marc.zyngier@arm.com, tomasz.nowicki@linaro.org, Naveen Kaje <nkaje@codeaurora.org>, rostedt@goodmis.org, sandeepa.s.prabhu@gmail.com, Dkvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, james.morse@arm.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, christoffer.dall@linaro.org
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 07, 2016 at 03:31:14PM -0600, Tyler Baicar wrote:
> +static void cper_estatus_print_section_v300(const char *pfx,
> +	const struct acpi_hest_generic_data_v300 *gdata)
> +{
> +	__u8 hour, min, sec, day, mon, year, century, *timestamp;
> +
> +	if (gdata->validation_bits & ACPI_HEST_GEN_VALID_TIMESTAMP) {
> +		timestamp = (__u8 *)&(gdata->time_stamp);
> +		memcpy(&sec, timestamp, 1);
> +		memcpy(&min, timestamp + 1, 1);
> +		memcpy(&hour, timestamp + 2, 1);
> +		memcpy(&day, timestamp + 4, 1);
> +		memcpy(&mon, timestamp + 5, 1);
> +		memcpy(&year, timestamp + 6, 1);
> +		memcpy(&century, timestamp + 7, 1);

This is utterly silly.  Why are you using memcpy() to access individual
bytes of a u8 pointer?  What's wrong with:

		sec = timestamp[0];
		min = timestamp[1];
		hour = timestamp[2];
		day = timestamp[4];
		mon = timestamp[5];
		year = timestamp[6];
		century = timestamp[7];

or even do the conversion here:

		sec = bcd2bin(timestamp[0]);
... etc ...

> +		printk("%stime: ", pfx);
> +		printk("%7s", 0x01 & *(timestamp + 3) ? "precise" : "");
> +		printk(" %02d:%02d:%02d %02d%02d-%02d-%02d\n",
> +			bcd2bin(hour), bcd2bin(min), bcd2bin(sec),
> +			bcd2bin(century), bcd2bin(year), bcd2bin(mon),
> +			bcd2bin(day));
> +	}

It's also a good idea to (as much as possible) keep to single printk()
statements - which makes the emission of the string more atomic wrt
other CPUs and contexts.  So, this should probably become (with the
conversion being done at the assignment of sec etc):

		printk("%stime: %7s %02d:%02d:%02d %02d%02d-%02d-%02d\n",
			pfx, 0x01 & timestamp[3] ? "precise" : "",
			hour, min, sec, century, year, mon, day);

which, IMHO, looks a lot nicer and doesn't risk some other printk()
getting between each individual part of the line.

> +}
> +
>  static void cper_estatus_print_section(
> -	const char *pfx, const struct acpi_hest_generic_data *gdata, int sec_no)
> +	const char *pfx, struct acpi_hest_generic_data *gdata, int sec_no)
>  {
>  	uuid_le *sec_type = (uuid_le *)gdata->section_type;
>  	__u16 severity;
>  	char newpfx[64];
>  
> +	if ((gdata->revision >> 8) >= 0x03)
> +		cper_estatus_print_section_v300(pfx,
> +			(const struct acpi_hest_generic_data_v300 *)gdata);
> +
>  	severity = gdata->error_severity;
>  	printk("%s""Error %d, type: %s\n", pfx, sec_no,
>  	       cper_severity_str(severity));

Not sure why you have the "" here - %sError works just as well and the
"" is just obfuscation - the compiler will eliminate the double-double
quote and merge the strings anyway.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
