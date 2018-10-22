From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v9 6/8] x86/boot: Dig out SRAT table from RSDP and find
 immovable memory
Date: Mon, 22 Oct 2018 14:08:14 +0800
Message-ID: <20181022060814.GL1885@192.168.1.4>
References: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
 <20181017102012.872-7-fanc.fnst@cn.fujitsu.com>
 <20181021023458.GJ1885@192.168.1.4>
 <B74D54765E346E448CD6C7B7B0334C258D95543F@G08CNEXMBSHAD01.g08.fujitsu.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B74D54765E346E448CD6C7B7B0334C258D95543F@G08CNEXMBSHAD01.g08.fujitsu.local>
Sender: linux-kernel-owner@vger.kernel.org
To: "Fan, Chao" <fanc.fnst@cn.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "keescook@chromium.org" <keescook@chromium.org>, "msys.mizuma@gmail.com" <msys.mizuma@gmail.com>, "Indoh, Takao" <indou.takao@fujitsu.com>, "Cao, Jin" <caoj.fnst@cn.fujitsu.com>
List-Id: linux-efi@vger.kernel.org

On 10/22/18 at 05:29am, Fan, Chao wrote:
> On Sun, Oct 21, 2018 at 10:34:58AM +0800, Baoquan He wrote:
> >On 10/17/18 at 06:20pm, Chao Fan wrote:
> >> +	if (!cmdline_find_option_bool("movable_node") ||
> >> +	    cmdline_find_option_arg("acpi", "off", 3))
> >> +		return;
> >> +
> >> +	table_header = get_acpi_srat_table();
> >> +	if (!table_header)
> >> +		return;
> >> +
> >> +	table_end = (unsigned long)table_header + table_header->length;
> >> +
> >> +	table = (struct acpi_subtable_header *)
> >> +		((unsigned long)table_header + sizeof(struct acpi_table_srat));
> >> +
> >> +	while (((unsigned long)table) +
> >> +		       sizeof(struct acpi_subtable_header) < table_end) {
> >> +		if (table->type == ACPI_SRAT_TYPE_MEMORY_AFFINITY) {
> >> +			ma = (struct acpi_srat_mem_affinity *)table;
> >> +			if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)) {
> >> +				immovable_mem[i].start = ma->base_address;
> >> +				immovable_mem[i].size = ma->length;
> >> +				i++;
> >> +			}
> >> +
> >> +			if (i >= MAX_NUMNODES*2)
> >		No warning message printed in this case?
> 
> I will add. BTW, what message is appropriate?
> I can't figure out in what condition, i >= MAX_NUMNODES*2.

Do you mean it's impossible to happen? 
