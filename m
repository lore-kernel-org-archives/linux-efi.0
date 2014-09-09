From: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [PATCH 0/4] x86/efi: Minor cleanup patches
Date: Tue, 9 Sep 2014 09:49:53 +0200
Message-ID: <CA+rthh-4d7pTQgo_aW7d0dh4Z1XsEopvavvFVyU2DyE3nwjOwQ@mail.gmail.com>
References: <1410111737-5220-1-git-send-email-minipli@googlemail.com>
	<20140908194105.GA18582@console-pimps.org>
	<CA+rthh8RWz1OhspgqrnX1uYq-Sc=WARx16AgxWBOoZrAD6-D_A@mail.gmail.com>
	<20140909072716.GF18582@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140909072716.GF18582-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 9 September 2014 09:27, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Tue, 09 Sep, at 09:03:31AM, Mathias Krause wrote:
>> On 8 September 2014 21:41, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
>> >
>> > Since they don't apply to the 'next' branch (queue for v3.18) and since
>> > they're cleanups with minimal risk, I've applied them to the 'urgent'
>> > branch.
>>
>> Sorry, I should have checked that! I can send a rebased version if you
>> want me to.
>
> Nah, don't worry. I usually prefer that people base their patches on
> Linus' tree and an -rc or final v3.x tag.
>
> I got some pushback from the tip folks on including these patches in an
> urgent pull request because they're not regression fixes. What I've now
> done is stuck them on the queue for v3.18 in 'next'.

That's okay, too. They're no urgent fixes, after all.

> Everything applied cleanly apart from "x86/efi: Unexport add_efi_memmap
> variable", because of recent changes to move the "noefi" handling code
> out of arch/x86.

Yeah. I tried a rebase and got the same conflict. It's easy to fix, though.

>
> I fixed up the conflict, but please take a look at the 'next' branch and
> see whether your rebased patches look correct.

Looks good. Thanks, Matt!

Cheers,
Mathias
