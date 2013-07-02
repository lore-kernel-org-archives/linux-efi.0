From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Date: Tue, 2 Jul 2013 09:29:50 +0200
Message-ID: <20130702072950.GA4036@Nokia-N900>
References: <20130620180808.GB19877@pd.tnic>
 <20130620181015.GA27833@srcf.ucam.org>
 <20130620181445.GA791@pd.tnic>
 <20130620181731.GA27960@srcf.ucam.org>
 <20130620184736.GC19877@pd.tnic>
 <51C383AC.4060706@zytor.com>
 <20130621072356.GA22006@pd.tnic>
 <ca8f8134-24d9-4f96-8876-e24892efc849@email.android.com>
 <20130621142101.GG22006@pd.tnic>
 <51C4827B.7090208@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51C4827B.7090208-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri 2013-06-21 09:42:35, H. Peter Anvin wrote:
> On 06/21/2013 07:21 AM, Borislav Petkov wrote:
> > On Fri, Jun 21, 2013 at 03:05:30AM -0700, H. Peter Anvin wrote:
> >> If you cap it you are basically imposing a constraint on the firmware
> >> and may not run properly (or at least have to turn off EFI runtime
> >> calls with all that implies.)
> > 
> > I don't want to cap EFI just for the fun of it but rather set a limit
> > so that the next one who wants a chunk of the virtual address space can
> > have a reliable limit from where she/he can start. Otherwise we won't
> > know where EFI reliably ends...
> > 
> 
> We don't... and I don't think there is anything we can do about it.  If
> some messed-up firmware wants to map a terabyte we either refuse and
> don't allow EFI runtime calls on that machine or we accept it.
> 
> Fortunately the space is extremely large and with growing down from a
> known address it is less likely that we'll conflict with something.

Hmm, will not setting up huge areas be slow?

Or we are going to use 2G pages or something?

Or should we make it slow on purpose so that at least server
vendors are discouraged from using big areas? :-)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
