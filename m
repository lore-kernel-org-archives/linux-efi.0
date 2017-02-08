From: "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/libstub/arm*: Set default address and size cells
 values for an empty dtb
Date: Wed, 8 Feb 2017 16:43:04 +0900
Message-ID: <20170208074301.GB18445@linaro.org>
References: <1486490390-25251-1-git-send-email-jhugo@codeaurora.org>
 <CAKv+Gu963uZB4MaMDuwTGd5-AqEN53Er8tExVLMZNVx3krJrZw@mail.gmail.com>
 <1f47fcdd-c5d8-4082-70a3-ca9b1746d7ca@codeaurora.org>
 <20170207190113.GG26173@leverpostej>
 <c49cc64e-4ca1-8d82-5faf-74c0355c35ef@codeaurora.org>
 <20170207191320.GI26173@leverpostej>
 <252539a6-72f6-1afa-6ed5-3cf6a1aa24c2@codeaurora.org>
 <20170207195558.GK26173@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170207195558.GK26173@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Sameer Goel <sgoel-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Mark,

Thank you for this heads-up.

On Tue, Feb 07, 2017 at 07:55:59PM +0000, Mark Rutland wrote:
> On Tue, Feb 07, 2017 at 12:29:38PM -0700, Jeffrey Hugo wrote:
> > On 2/7/2017 12:13 PM, Mark Rutland wrote:
> > >On Tue, Feb 07, 2017 at 12:07:56PM -0700, Jeffrey Hugo wrote:
> > >>On 2/7/2017 12:01 PM, Mark Rutland wrote:
> > >>>I take it this is specific to the kdump properties?
> > >>>
> > >>>I can't immediately see what would matter for the !kdump case.
> > >>>properties inserted under /chosen are not truncated?
> > >>
> > >>The kexec/kdump properties are added under /chosen, therefore yes,
> > >>properties added under /chosen are truncated, per our observations.
> > >
> > >Sorry for the dodgy (and confusing) reply above.
> > >
> > >What I was trying to ask was does this *only* affect kdump properties?
> > >I note that kdump is not yet upstream for arm64.
> > >
> > >Or are there regular kexec properties that this affects?
> > >
> > >Or !kdump && !kexec properties?
> > >
> > >Can you please enumerate the set of properties for which this matters?
> > 
> > "linux,elfcorehdr" and "linux,usable-memory-range"
> > 
> > We are not aware of !kdump && !kexec properties where this is an issue.
> 
> Ok, I understand the problem now. Thanks for clarifying the !kdump
> situation.
> 
> As per my reply to Timur, given this only affects kdump, this is all
> happening in code that is not upstream, and therefore this is not
> *currently* an issue.
> 
> In future, please report this kind of issue in reply to relevant
> postings (e.g. [1]). At the very least, refer to these, with relevant
> people Cc'd (e.g. Takahiro-san in this case).
> 
> I think there are three things which should happen:
> 
> (a) The userspace kexec-tools kdump code should take /#address-cells and
>     /#size-cells into account when inserting the linux,elfcorehdr and
>     linux,usable-memory-range properties. There can be DTs for 64 bit
>     platforms where these are not 2.
>     
>     Takahiro-san, from looking at your kexec-tools repo, this is not
>     currently the case. Could you address that?

Yup, I will, but if this is the case,
we might need to think about another case where /#address-cells and /#size-cells
are <1> but the range of crash dump kernel can be still 64-bit wide since
the system memory information comes from ACPI table (not DT).

Therefore, the properties in this case should look like:
/ {
    #address-cells = <1>;
    #size-cells = <1>;
    chosen {
         ...
         linux,usable-memory-range {
             #address-cells = <2>;
             #size-cells = <2>; may be omitted if possible
             reg = < ... >;
         }
         linux,elfcorehdr {
             #address-cells = <2>;
             #size-cells = <2>; may be omitted if possible
             reg = < ... >;
         }
         ...
    }
}

Is this what you meant?
(Obviously, I will have to modify the kernel patches as well.)

Thanks,
-Takahiro AKASHI


> (b) The kdump documentation should updated to explicitly state that
>     these properties are #address-cells + #size-cells tuples, since this
>     is clearly going to be confusing either way. I'll try to come up
>     with wording for that, and I'll reply on the current [1] kdump
>     thread.
> 
> (c) Regardless, when creating the empty DT the EFI stub should insert
>     /#address-cells = <2> and /#size-cells = <2>. That better aligns
>     with the usual requirements for an otherwise empty DTB, and avoids a
>     tonne of fragility when the DTB is passed on or altered by other
>     agents.
> 
> So, please respin this patch, stating explicitly what this matters for.
> 
> Thanks,
> Mark.
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-February/486234.html 
