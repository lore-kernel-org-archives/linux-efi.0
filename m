From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Tue, 16 Oct 2018 15:54:30 -0400
Message-ID: <20181016195429.tovdgqq77gz3eek2@gabell>
References: <20181010194443.sgdvplwdnltshwwi@gabell>
 <20181011002955.GJ25297@MiWiFi-R3L-srv>
 <20181011055154.GB6667@localhost.localdomain>
 <20181013201958.zfzv5ahhe3xz7bwi@gabell>
 <20181013203429.GE31650@zn.tnic>
 <20181013214550.ag5qzokhkrkwnzsy@gabell>
 <20181013220541.GI31650@zn.tnic>
 <20181015005035.z3xym6nx43hogdge@gabell>
 <20181016151353.punyk7exekut2543@gabell>
 <20181016191113.GI5212@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181016191113.GI5212@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Chao Fan <fanc.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Tue, Oct 16, 2018 at 09:11:14PM +0200, Borislav Petkov wrote:
> On Tue, Oct 16, 2018 at 11:13:54AM -0400, Masayoshi Mizuma wrote:
> > Hi Boris, Baoquan and all,
> > 
> > I have created a RFC patch for adjust KASLR padding size.
> > This patch is based on Can's v8 patch [1/3], and the Can's patch
> > will be changed in the future, so this patch is just RFC.
> > 
> > Welcome to any comments and suggestions. Thanks!
> 
> ...
> 
> > diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
> > index a06cbf019744..c987c725e93a 100644
> > --- a/arch/x86/include/uapi/asm/bootparam.h
> > +++ b/arch/x86/include/uapi/asm/bootparam.h
> > @@ -191,7 +191,8 @@ struct boot_params {
> >  	__u8  _pad7[0x290-0x1f1-sizeof(struct setup_header)];
> >  	__u32 edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];	/* 0x290 */
> >  	struct boot_e820_entry e820_table[E820_MAX_ENTRIES_ZEROPAGE]; /* 0x2d0 */
> > -	__u8  _pad8[48];				/* 0xcd0 */
> > +	__u8  _pad8[40];				/* 0xcd0 */
> > +	__u64 possible_mem_addr;			/* 0xcf8 */
> 
> Where in the example I gave you with add_e820ext() do you see members
> being added to struct boot_params?
> 
> Take a look at it again pls.

Ah, sorry, I misunderstood your suggetion...
In parse_setup_data(), the data is picked up from boot_params,
so I thought it is also useful for this sitiation.
I'll try again, thanks!

- Masa
