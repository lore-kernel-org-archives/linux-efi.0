From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Mon, 11 Feb 2019 15:11:20 -0500
Message-ID: <20190211201118.pot6347rp2ieljel@gabell>
References: <20181025134050.ggiir77ehntikbwg@gabell>
 <20181106184519.GA16391@zn.tnic>
 <20181106193636.svyjwuwrlgnpuyyf@gabell>
 <20181106204511.GO13712@zn.tnic>
 <20181106222133.lb7674yzszivzihd@gabell>
 <20181108105129.GA7543@zn.tnic>
 <20181110105422.GA20023@zn.tnic>
 <20181111134556.qxv2v4g7dl5irzo7@gabell>
 <20190205150514.fvztftk75swgfayd@gabell>
 <20190211014605.GC1544@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211014605.GC1544@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

Hi Chao,

Thank you for your review.

On Mon, Feb 11, 2019 at 09:46:05AM +0800, Chao Fan wrote:
> On Tue, Feb 05, 2019 at 10:05:16AM -0500, Masayoshi Mizuma wrote:
> [...]
> 
> Hi Masa,
> 
> Sorry for delay, since last days were Chinese holiday.
> 
> >diff --git a/arch/x86/boot/compressed/acpi.c b/arch/x86/boot/compressed/acpi.c
> >index c5a949335..7dd61b943 100644
> >--- a/arch/x86/boot/compressed/acpi.c
> >+++ b/arch/x86/boot/compressed/acpi.c
> >@@ -288,6 +288,7 @@ int count_immovable_mem_regions(void)
> > 	struct acpi_subtable_header *sub_table;
> > 	struct acpi_table_header *table_header;
> > 	char arg[MAX_ACPI_ARG_LENGTH];
> >+	unsigned long long possible_addr, max_possible_addr = 0;
> 
> This line is so long that it should be added in first line.

Thanks. I will simplify around the local variables.

> 
> > 	int num = 0;
> > 
> > 	if (cmdline_find_option("acpi", arg, sizeof(arg)) == 3 &&
> >@@ -308,10 +309,19 @@ int count_immovable_mem_regions(void)
> > 			struct acpi_srat_mem_affinity *ma;
> > 
> > 			ma = (struct acpi_srat_mem_affinity *)sub_table;
> >-			if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && ma->length) {
> >-				immovable_mem[num].start = ma->base_address;
> >-				immovable_mem[num].size = ma->length;
> >-				num++;
> >+			if (ma->length) {
> >+				if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
> >+					possible_addr =
> >+						ma->base_address + ma->length;
> >+					if (possible_addr > max_possible_addr)
> >+						max_possible_addr =
> >+							possible_addr;
> >+				} else {
> >+					immovable_mem[num].start =
> >+						ma->base_address;
> >+					immovable_mem[num].size = ma->length;
> >+					num++;
> >+				}
> > 			}
> 
> It looks better in another mail where you add a new function.

Thanks!

- Masa
