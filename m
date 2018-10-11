From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Thu, 11 Oct 2018 13:51:54 +0800
Message-ID: <20181011055154.GB6667@localhost.localdomain>
References: <20181010084119.17539-1-fanc.fnst@cn.fujitsu.com>
 <20181010085920.GB5533@zn.tnic>
 <20181010090620.GF25297@MiWiFi-R3L-srv>
 <alpine.DEB.2.21.1810101113070.10278@nanos.tec.linutronix.de>
 <20181010091923.GC5533@zn.tnic>
 <20181010093057.GA22088@MiWiFi-R3L-srv>
 <20181010194443.sgdvplwdnltshwwi@gabell>
 <20181011002955.GJ25297@MiWiFi-R3L-srv>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181011002955.GJ25297@MiWiFi-R3L-srv>
Sender: linux-kernel-owner@vger.kernel.org
To: Baoquan He <bhe@redhat.com>
Cc: Masayoshi Mizuma <msys.mizuma@gmail.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 11, 2018 at 08:29:55AM +0800, Baoquan He wrote:
>On 10/10/18 at 03:44pm, Masayoshi Mizuma wrote:
>> On Wed, Oct 10, 2018 at 05:30:57PM +0800, Baoquan He wrote:
>> > On 10/10/18 at 11:19am, Borislav Petkov wrote:
>> > > On Wed, Oct 10, 2018 at 11:14:26AM +0200, Thomas Gleixner wrote:
>> > > > Yes, it's different, but if the SRAT information is available early, then
>> > > > the command line parameter can go away because then the required
>> > > > information for Masa's problem is available as well.
>> > > 
>> > > Exactly. And I'd prefer we delayed the command line parameter until we
>> > > figure out we really need it and not expose it to upstream and then
>> > > remove it shortly after.
>> > > 
>> > > So I'd suggest we move Masa's patches to a separate branch and not send
>> > > it up this round.
>> > 
>> > Yes, sounds more reasonable if we can reuse functions in Chao's patch 1/3
>> > to solve the padding issue.
>> 
>> Thanks for your comments! Yes, immovable_mem[num_immovable_mem] in Chao's
>> patch may be useful for calculating the padding size. If so, we don't
>> need the new kernel parameter. It's nice!
>> 
>> Do you happen to have ideas how we access immovable_mem[num_immovable_mem]
>> from arch/x86/mm/kaslr.c ? It is located to arch/x86/boot/compressed/*, so
>> I suppose it is not easy to access it... 
>> I would appreciate if you could give some advice.
>
>Hmm, they are living in different life cycle and space. So we can only
>reuse the code from Chao's patch, but not the variable. Means we need
>go through the SRAT accessing again in arch/x86/mm/kaslr.c and fill
>immovable_mem[num_immovable_mem] for mm/kaslr.c usage, if we decide to
>do like that.

Reading three times is redundant, but reading two times is needed.
Becasue the ACPI code run very stable, but we need more information
before that.
As for Masa's issue, I am wondering whether we can tranfer the
information or only the address of SRAT table from compressed period
to the period after start_kernel().

Thanks,
Chao Fan

>
>Thanks
>Baoquan
>
>
