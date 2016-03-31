From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 12/17] ARM64: ACPI: Check if it runs on Xen to enable
 or disable ACPI
Date: Thu, 31 Mar 2016 13:44:08 +0200
Message-ID: <CAKv+Gu-wPq_FzO3sm7bhSFuu7EVxHWB_v6HOn1GqNbdaE-iBoQ@mail.gmail.com>
References: <1458830676-27075-1-git-send-email-shannon.zhao@linaro.org>
	<1458830676-27075-13-git-send-email-shannon.zhao@linaro.org>
	<20160329161837.GH6745@arm.com>
	<20160329163147.GB27223@leverpostej>
	<56FB7E00.7030400@huawei.com>
	<alpine.DEB.2.02.1603311155450.11739@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1603311155450.11739-7Z66fg9igcxYtxbxJUhB2Dgeux46jI+i@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Cc: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Huangpeng (Peter)" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, julien.grall-5wv7dgnIgG8@public.gmane.org, Stefano Stabellini <stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 31 March 2016 at 13:04, Stefano Stabellini
<stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org> wrote:
> On Wed, 30 Mar 2016, Shannon Zhao wrote:
>> Hi Will, Mark,
>>
>> On 2016/3/30 0:31, Mark Rutland wrote:
>> > On Tue, Mar 29, 2016 at 05:18:38PM +0100, Will Deacon wrote:
>> >> > On Thu, Mar 24, 2016 at 10:44:31PM +0800, Shannon Zhao wrote:
>> >>> > > When it's a Xen domain0 booting with ACPI, it will supply a /chosen and
>> >>> > > a /hypervisor node in DT. So check if it needs to enable ACPI.
>> >>> > >
>> >>> > > Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> >>> > > Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
>> >>> > > Acked-by: Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> >>> > > ---
>> >>> > >  arch/arm64/kernel/acpi.c | 12 ++++++++----
>> >>> > >  1 file changed, 8 insertions(+), 4 deletions(-)
>> >>> > >
>> >>> > > diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>> >>> > > index d1ce8e2..4e92be0 100644
>> >>> > > --- a/arch/arm64/kernel/acpi.c
>> >>> > > +++ b/arch/arm64/kernel/acpi.c
>> >>> > > @@ -67,10 +67,13 @@ static int __init dt_scan_depth1_nodes(unsigned long node,
>> >>> > >  {
>> >>> > >       /*
>> >>> > >        * Return 1 as soon as we encounter a node at depth 1 that is
>> >>> > > -      * not the /chosen node.
>> >>> > > +      * not the /chosen node, or /hypervisor node when running on Xen.
>> >>> > >        */
>> >>> > > -     if (depth == 1 && (strcmp(uname, "chosen") != 0))
>> >>> > > -             return 1;
>> >>> > > +     if (depth == 1 && (strcmp(uname, "chosen") != 0)) {
>> >>> > > +             if (!xen_initial_domain() || (strcmp(uname, "hypervisor") != 0))
>> >>> > > +                     return 1;
>> >>> > > +     }
>> >> >
>> >> > Hmm, but xen_initial_domain() is false when xen isn't being used at all,
>> >> > so it feels to me like this is a bit too far-reaching and is basically
>> >> > claiming the "/hypervisor" namespace for Xen. Couldn't it be renamed to
>> >> > "xen,hypervisor" or something?
>> >> >
>> >> > Mark, got any thoughts on this?
>> > The node has a compatible string, "xen,xen" per [1], which would tell us
>> > absolutely that xen is present. I'd be happy checking for that
>> > explicitly.
>> >
>> I think actually the xen_initial_domain is the result of the
>> fdt_find_hyper_node. If the compatible string "xen,xen" doesn't exist,
>> the xen_initial_domain() will return false and whatever the current node
>> is the above check will return 1 since the device tree is not empty.
>
> Right.
>
> xen_initial_domain implies both "xen,xen" and XENFEAT_dom0 (which is a
> feature retrieved by making a XENVER_get_features hypercall, see
> drivers/xen/features.c:xen_setup_features).
>
> So the following check:
>
>  +     if (!xen_initial_domain() || (strcmp(uname, "hypervisor") != 0))
>  +         return 1;
>
> means that even if it's xen_initial_domain(), return error unless the
> node found is "hypervisor". In other words, even if
> xen_initial_domain(), no other nodes are allowed except /chosen and
> /hypervisor.
>
> This doesn't look far reaching to me, but yes, we could check explicitly
> for the node to be compatible "xen,xen", in addition to be named
> "hypervisor", even though the check is already done elsewhere
> (arch/arm/xen/enlighten.c).
>
> But I would keep it as it is.
>

The heuristic is there to decide whether some DTB image contains a
complete description of the platform, or only some data handed over by
the bootloader. Arguably, a DT containing both /chosen and /hypervisor
but nothing else can still not describe an actual platform, and
whether we execute under Xen or not is completely irrelevant.

So this should be sufficient imo

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index d1ce8e2f98b9..d6d61e2e4d49 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -67,9 +67,10 @@ static int __init dt_scan_depth1_nodes(unsigned long node,
 {
        /*
         * Return 1 as soon as we encounter a node at depth 1 that is
-        * not the /chosen node.
+        * not the /chosen node or the /hypervisor node.
         */
-       if (depth == 1 && (strcmp(uname, "chosen") != 0))
+       if (depth == 1 && strcmp(uname, "chosen") != 0 &&
+           strcmp(uname, "hypervisor") != 0)
                return 1;
        return 0;
 }



>> > In patch 11 fdt_find_hyper_node checks the compatible string. We could
>> > factor that out into a helper like is_xen_node(node) and use it here
>> > too.
>> >
>> I don't think so because we already check the compatible string before
>> and we could get the result simply via xen_initial_domain().
>
> We could add a comment saying xen_initial_domain() implies "xen,xen" or
> something.
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
