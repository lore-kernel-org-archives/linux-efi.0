From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v9 5/8] x86/boot: Add get_acpi_rsdp() to parse RSDP in
 cmdlien from kexec
Date: Mon, 22 Oct 2018 15:36:46 +0800
Message-ID: <20181022073646.GM1885@192.168.1.4>
References: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
 <20181017102012.872-6-fanc.fnst@cn.fujitsu.com>
 <20181021022650.GI1885@192.168.1.4>
 <B74D54765E346E448CD6C7B7B0334C258D955469@G08CNEXMBSHAD01.g08.fujitsu.local>
 <20181022060613.GK1885@192.168.1.4>
 <20181022073050.GB7641@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181022073050.GB7641@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: dyoung@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "keescook@chromium.org" <keescook@chromium.org>, "msys.mizuma@gmail.com" <msys.mizuma@gmail.com>, "Indoh, Takao" <indou.takao@fujitsu.com>, "Cao, Jin" <caoj.fnst@cn.fujitsu.com>
List-Id: linux-efi@vger.kernel.org

On 10/22/18 at 03:30pm, Chao Fan wrote:
> On Mon, Oct 22, 2018 at 02:06:13PM +0800, Baoquan He wrote:
> >On 10/22/18 at 05:30am, Fan, Chao wrote:
> >> >> +static void get_acpi_rsdp(acpi_physical_address *rsdp_addr)
> >> >> +{
> >> >> +#ifdef CONFIG_KEXEC
> >> >> +	unsigned long long res;
> >> >> +	int len = 0;
> >> >> +	char *val;
> >> >> +
> >> >> +	val = malloc(20);
> >> >
> >> >Why is the length 20? Defined a macro?
> >> >
> >> 
> >> Not a calculation, if it's enough to store the address, that will be OK.
> >
> >Sorry, I didn't catch. It's 16 in setup_acpi_rsdp() of
> >drivers/acpi/osl.c . What does 'that' mean?
> 
> The second parameter of kstrtoull(), the 16 you mentioned means
> hexadecimal, not the length.

Yes, you are right.

> I checked my host and guest, the value are ACPI20=0xbfbfa014, ACPI20=0xdb807000.
> The length of memory is 8. Well the max memory address is 16, add
> "0x" and '\0' is 19. So I set it as 20.
> I am not sure whether 8 is enough for the address, if OK, 11 will
> be enough, or 19 is OK.

I am fine with 20. Thanks.
