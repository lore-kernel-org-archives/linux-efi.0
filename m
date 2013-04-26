From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fix
Date: Fri, 26 Apr 2013 17:48:45 +0100
Message-ID: <20130426164845.GD23038@console-pimps.org>
References: <20130426163022.GC23038@console-pimps.org>
 <CA+55aFw+EOcVvz-3Sc-khBuLsMo64pp8PDO_UwidH07vbC08pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFw+EOcVvz-3Sc-khBuLsMo64pp8PDO_UwidH07vbC08pA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 26 Apr, at 09:40:46AM, Linus Torvalds wrote:
> On Fri, Apr 26, 2013 at 9:30 AM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> > Hi Peter, Linus,
> >
> > I've got a small patch that fixes a crash for the Google folks and their
> > EFI SMI driver, which was caused by dereferencing a garbage pointer.
> 
> Hmm. I already took this from the earlier email you sent. Did it change since?

Nope, there hasn't been any change. I just didn't know whether you
preferred to take the fix via email or a pull request.

Thanks for picking this up.

-- 
Matt Fleming, Intel Open Source Technology Center
