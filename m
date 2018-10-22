From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v9 5/8] x86/boot: Add get_acpi_rsdp() to parse RSDP in
 cmdlien from kexec
Date: Mon, 22 Oct 2018 14:06:13 +0800
Message-ID: <20181022060613.GK1885@192.168.1.4>
References: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
 <20181017102012.872-6-fanc.fnst@cn.fujitsu.com>
 <20181021022650.GI1885@192.168.1.4>
 <B74D54765E346E448CD6C7B7B0334C258D955469@G08CNEXMBSHAD01.g08.fujitsu.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B74D54765E346E448CD6C7B7B0334C258D955469@G08CNEXMBSHAD01.g08.fujitsu.local>
Sender: linux-kernel-owner@vger.kernel.org
To: "Fan, Chao" <fanc.fnst@cn.fujitsu.com>, dyoung@redhat.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "keescook@chromium.org" <keescook@chromium.org>, "msys.mizuma@gmail.com" <msys.mizuma@gmail.com>, "Indoh, Takao" <indou.takao@fujitsu.com>, "Cao, Jin" <caoj.fnst@cn.fujitsu.com>
List-Id: linux-efi@vger.kernel.org

On 10/22/18 at 05:30am, Fan, Chao wrote:
> >> +static void get_acpi_rsdp(acpi_physical_address *rsdp_addr)
> >> +{
> >> +#ifdef CONFIG_KEXEC
> >> +	unsigned long long res;
> >> +	int len = 0;
> >> +	char *val;
> >> +
> >> +	val = malloc(20);
> >
> >Why is the length 20? Defined a macro?
> >
> 
> Not a calculation, if it's enough to store the address, that will be OK.

Sorry, I didn't catch. It's 16 in setup_acpi_rsdp() of
drivers/acpi/osl.c . What does 'that' mean?

Wondering why not making it 200, it's also enough to store the address.
