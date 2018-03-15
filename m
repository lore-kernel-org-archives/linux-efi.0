From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] arm64: extra entries in /proc/iomem for kexec
Date: Thu, 15 Mar 2018 07:33:45 +0000
Message-ID: <CAKv+Gu8-T84wExeMvJZyVCyY6vsEwWZ3Mhc1v+dRA7yqxxUOsQ@mail.gmail.com>
References: <20180314082941.GM25863@linaro.org>
 <CAKv+Gu9AMS4sGoRsw0KNv6+3WZPXCJRfbxBnjaqnZugiZe4o9w@mail.gmail.com>
 <20180315044109.GN25863@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20180315044109.GN25863-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Jeff Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 15 March 2018 at 04:41, AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Mar 14, 2018 at 08:39:23AM +0000, Ard Biesheuvel wrote:
>> On 14 March 2018 at 08:29, AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> > In the last couples of months, there were some problems reported [1],[2]
>> > around arm64 kexec/kdump. Where those phenomenon look different,
>> > the root cause would be that kexec/kdump doesn't take into account
>> > crucial "reserved" regions of system memory and unintentionally corrupts
>> > them.
>> >
>> > Given that kexec-tools looks for all the information by seeking the file,
>> > /proc/iomem, the first step to address said problems is to expand this file's
>> > format so that it will have enough information about system memory and
>> > its usage.
>> >
>> > Attached is my experimental code: With this patch applied, /proc/iomem sees
>> > something like the below:
>> >
>> > (format A)
>> > 40000000-5871ffff : System RAM
>> >   40080000-40f1ffff : Kernel code
>> >   41040000-411e8fff : Kernel data
>> >   54400000-583fffff : Crash kernel
>> >   58590000-585effff : EFI Resources
>> >   58700000-5871ffff : EFI Resources
>> > 58720000-58b5ffff : System RAM
>> >   58720000-58b5ffff : EFI Resources
>> > 58b60000-5be3ffff : System RAM
>> >   58b61018-58b61947 : EFI Memory Map
>> >   59a7b118-59a7b667 : EFI Configuration Tables
>> > 5be40000-5becffff : System RAM                  <== (A-1)
>> >   5be40000-5becffff : EFI Resources
>> > 5bed0000-5bedffff : System RAM
>> > 5bee0000-5bffffff : System RAM
>> >   5bee0000-5bffffff : EFI Resources
>> > 5c000000-5fffffff : System RAM
>> > 8000000000-ffffffffff : PCI Bus 0000:00
>> >
>> > Meanwhile, the workaround I suggested in [3] gave us a simpler view:
>> >
>> > (format B)
>> > 40000000-5871ffff : System RAM
>> >   40080000-40f1ffff : Kernel code
>> >   41040000-411e9fff : Kernel data
>> >   54400000-583fffff : Crash kernel
>> >   58590000-585effff : reserved
>> >   58700000-5871ffff : reserved
>> > 58720000-58b5ffff : reserved
>> > 58b60000-5be3ffff : System RAM
>> >   58b61000-58b61fff : reserved
>> >   59a7b318-59a7b867 : reserved
>> > 5be40000-5becffff : reserved                    <== (B-1)
>> > 5bed0000-5bedffff : System RAM
>> > 5bee0000-5bffffff : reserved
>> > 5c000000-5fffffff : System RAM
>> >   5ec00000-5edfffff : reserved
>> > 8000000000-ffffffffff : PCI Bus 0000:00
>> >
>> > Here all the regions to be protected are named just "reserved" whether
>> > they are NOMAP regions or simply-memblock_reserve'd. They are not very
>> > useful for anything but kexec/kdump which knows what they mean.
>> >
>> > Alternatively, we may want to give them more specific names, based on
>> > related efi memory map descriptors and else, that will characterize
>> > their contents:
>> >
>> > (format C)
>> > 40000000-5871ffff : System RAM
>> >   40080000-40f1ffff : Kernel code
>> >   41040000-411e9fff : Kernel data
>> >   54400000-583fffff : Crash kernel
>> >   58590000-585effff : ACPI Reclaim Memory
>> >   58700000-5871ffff : ACPI Reclaim Memory
>> > 58720000-58b5ffff : System RAM
>> >   58720000-5878ffff : Runtime Data
>> >   58790000-587dffff : Runtime Code
>> >   587e0000-5882ffff : Runtime Data
>> >   58830000-5887ffff : Runtime Code
>> >   58880000-588cffff : Runtime Data
>> >   588d0000-5891ffff : Runtime Code
>> >   58920000-5896ffff : Runtime Data
>> >   58970000-589bffff : Runtime Code
>> >   589c0000-58a5ffff : Runtime Data
>> >   58a60000-58abffff : Runtime Code
>> >   58ac0000-58b0ffff : Runtime Data
>> >   58b10000-58b5ffff : Runtime Code
>> > 58b60000-5be3ffff : System RAM
>> >   58b61000-58b61fff : EFI Memory Map
>> >   59a7b118-59a7b667 : EFI Memory Attributes Table
>> > 5be40000-5becffff : System RAM
>> >   5be40000-5becffff : Runtime Code
>> > 5bed0000-5bedffff : System RAM
>> > 5bee0000-5bffffff : System RAM
>> >   5bee0000-5bffffff : Runtime Data
>> > 5c000000-5fffffff : System RAM
>> > 8000000000-ffffffffff : PCI Bus 0000:00
>> >
>> > I once created a patch for this format, but it looks quite noisy and
>> > names are a sort of mixture of memory attributes( ACPI Reclaim memory,
>> > Conventional Memory, Persistent Memory etc.) vs.
>> > function/usages ([Loader|Boot Service|Runtime] Code/Data).
>> > (As a matter of fact, (C-1) consists of various ACPI tables.)
>> > Anyhow, they seem not so useful for most of other applications.
>> >
>> > Those observations lead to format A, where some entries with the same
>> > attributes are squeezed into a single entry under a simple name if they
>> > are neighbouring.
>> >
>> >
>> > So my questions here are:
>> >
>> > 1. Which format, A, B, or C, is the most appropriate for the moment?
>> >    or any other suggestions?
>> >
>>
>> I think some variant of B should be sufficient. The only meaningful
>> distinction between these reserved regions at a general level is
>> whether they are NOMAP or not, so perhaps we can incorporate that.
>
> I would definitely like to give your opinion the first priority,
> but also hear from other guys.
>
> Can you tell my why you think that the distinction, NOMAP or not,
> is meaningful?
>

For diagnostic purposes, it may be useful to know whether a certain
address is covered by the linear mapping or not.

>> As for identifying things like EFI configuration tables: this is a
>> moving target, and we also define our own config tables for the TPM
>> log, screeninfo on ARM etc. Also, for EFI memory types, you can boot
>> with efi=debug and look at the entire memory map. So I think adding
>> all that information may be overkill.
>
> No doubt I agree.
> The reason why I gave specific names to EFI configuration tables
> is that all such tables are unambiguously listed in 'efi' structure,
> while "screen info" seems to be arm-specific.
> As for EFI memory types, I admit that they are inadequate for a source
> of naming.
> Nevertheless, I still have a sense that "reserved" sounds sloppy :)
>

I don't think that sounds sloppy at all.

>> > Currently, there is a inconsistent view between (A) and the mainline's:
>> > see (A-1) and (B-1). If this is really a matter, I can fix it.
>> > Kexec-tools can be easily modified to accept both formats, though.
>> >
>> >
>> > 2. How should we determine which regions be exported in /proc/iomem?
>> >
>> >  a. Trust all the memblock_reserve'd regions as my previous patch [3] does.
>> >
>> >     As I said, it's a kind of "overkill." Some of regions, say fdt, are
>> >     not required to be preserved across kexec.
>> >
>>
>> I don't think there is anything wrong with listing all
>> memblock_reserve()'d regions here, even if kexec has other means of
>> ensuring that they are not touched.
>
> I initially thought that one downside in this approach is that we might
> not able to re-use a reserved region for fdt, as well as others also
> dynamically reserved by "/reserved-memory/" nodes, after kexec and that
> it would end up more or less a memory leak eventually after iterating
> kexec()'s. But
> after thinking twice, I now don't believe it is a problem anymore.
> In kexec case, we won't have to hand over a list of reserved regions to
> secondary kernel. Kdump, on the other hand, will be triggered only once
> for its nature anyway.
>
>> But as I said, I think it would be
>> useful to distinguish them from NOMAP regions (even if the nesting
>> below System RAM already shows that as well)
>
> Something like "reserved (no map)"?
>

Works for me
