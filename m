From: "AKASHI, Takahiro" <takahiro.akashi@linaro.org>
Subject: Re: [PATCH] efi/libstub/arm*: Set default address and size cells
 values for an empty dtb
Date: Thu, 9 Feb 2017 17:27:04 +0900
Message-ID: <20170209082702.GC18445@linaro.org>
References: <1486490390-25251-1-git-send-email-jhugo@codeaurora.org>
 <CAKv+Gu963uZB4MaMDuwTGd5-AqEN53Er8tExVLMZNVx3krJrZw@mail.gmail.com>
 <1f47fcdd-c5d8-4082-70a3-ca9b1746d7ca@codeaurora.org>
 <20170207190113.GG26173@leverpostej>
 <c49cc64e-4ca1-8d82-5faf-74c0355c35ef@codeaurora.org>
 <20170207191320.GI26173@leverpostej>
 <252539a6-72f6-1afa-6ed5-3cf6a1aa24c2@codeaurora.org>
 <20170207195558.GK26173@leverpostej>
 <20170208074301.GB18445@linaro.org>
 <CAKv+Gu8OXn20JvtFkE_bS=cbWV3XZ5b7a+XaG7tvea+4BqrHfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8OXn20JvtFkE_bS=cbWV3XZ5b7a+XaG7tvea+4BqrHfw@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Jeffrey Hugo <jhugo@codeaurora.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Sameer Goel <sgoel@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 08, 2017 at 10:40:53AM +0000, Ard Biesheuvel wrote:
> On 8 February 2017 at 07:43, AKASHI, Takahiro
> <takahiro.akashi@linaro.org> wrote:
> > Hi Mark,
> >
> > Thank you for this heads-up.
> >
> > On Tue, Feb 07, 2017 at 07:55:59PM +0000, Mark Rutland wrote:
> >> On Tue, Feb 07, 2017 at 12:29:38PM -0700, Jeffrey Hugo wrote:
> >> > On 2/7/2017 12:13 PM, Mark Rutland wrote:
> >> > >On Tue, Feb 07, 2017 at 12:07:56PM -0700, Jeffrey Hugo wrote:
> >> > >>On 2/7/2017 12:01 PM, Mark Rutland wrote:
> >> > >>>I take it this is specific to the kdump properties?
> >> > >>>
> >> > >>>I can't immediately see what would matter for the !kdump case.
> >> > >>>properties inserted under /chosen are not truncated?
> >> > >>
> >> > >>The kexec/kdump properties are added under /chosen, therefore yes,
> >> > >>properties added under /chosen are truncated, per our observations.
> >> > >
> >> > >Sorry for the dodgy (and confusing) reply above.
> >> > >
> >> > >What I was trying to ask was does this *only* affect kdump properties?
> >> > >I note that kdump is not yet upstream for arm64.
> >> > >
> >> > >Or are there regular kexec properties that this affects?
> >> > >
> >> > >Or !kdump && !kexec properties?
> >> > >
> >> > >Can you please enumerate the set of properties for which this matters?
> >> >
> >> > "linux,elfcorehdr" and "linux,usable-memory-range"
> >> >
> >> > We are not aware of !kdump && !kexec properties where this is an issue.
> >>
> >> Ok, I understand the problem now. Thanks for clarifying the !kdump
> >> situation.
> >>
> >> As per my reply to Timur, given this only affects kdump, this is all
> >> happening in code that is not upstream, and therefore this is not
> >> *currently* an issue.
> >>
> >> In future, please report this kind of issue in reply to relevant
> >> postings (e.g. [1]). At the very least, refer to these, with relevant
> >> people Cc'd (e.g. Takahiro-san in this case).
> >>
> >> I think there are three things which should happen:
> >>
> >> (a) The userspace kexec-tools kdump code should take /#address-cells and
> >>     /#size-cells into account when inserting the linux,elfcorehdr and
> >>     linux,usable-memory-range properties. There can be DTs for 64 bit
> >>     platforms where these are not 2.
> >>
> >>     Takahiro-san, from looking at your kexec-tools repo, this is not
> >>     currently the case. Could you address that?
> >
> > Yup, I will, but if this is the case,
> > we might need to think about another case where /#address-cells and /#size-cells
> > are <1> but the range of crash dump kernel can be still 64-bit wide since
> > the system memory information comes from ACPI table (not DT).
> >
> > Therefore, the properties in this case should look like:
> > / {
> >     #address-cells = <1>;
> >     #size-cells = <1>;
> >     chosen {
> >          ...
> >          linux,usable-memory-range {
> >              #address-cells = <2>;
> >              #size-cells = <2>; may be omitted if possible
> >              reg = < ... >;
> >          }
> >          linux,elfcorehdr {
> >              #address-cells = <2>;
> >              #size-cells = <2>; may be omitted if possible
> >              reg = < ... >;
> >          }
> >          ...
> >     }
> > }
> >
> > Is this what you meant?
> > (Obviously, I will have to modify the kernel patches as well.)
> >
> 
> I think the cell sizes of reg properties are defined in terms of the
> #address/size-cells attributes of the parent node. This makes sense
> when you think of it, because the regs of all nodes under the same
> parent should have the same size, given that they all live in their
> parent's address space. Of course, /chosen is special since it does
> not describe a bus.

I see.

> So that means the tooling /could/ inject #address-cells/size-cells
> properties either at the root, or in /chosen, but not in the kdump

/chosen, too?
Now I believe that /chosen should not have #address-cells/size-cells
because there is no assumption that all the nodes under /chosen
have the same values for #address-cells/#size-cells.
(Anyhow, this is very exceptional given the meanings of /chosen.)

> properties themselves. However, that is not the point.
> 
> The point is that the tooling should take *existing* cell counts into
> account: if there are no address-cells/size-cells properties under
> /chosen or under the root node, the tooling should use 32-bit
> quantities for address and size. If there are such properties, it
> should emit reg tuples of the same size as the cells properties
> describe.

Let me make sure one thing:
is there a requirement that the root node must have #address-cells/
#size-cells?
I found such a statement, at least, in booting-without-of.txt
(only applied to ppc? See III-5-a).

Thanks,
-Takahiro AKASHI
