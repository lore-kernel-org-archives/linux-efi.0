From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [BUG] Linux 3.14 fails to boot with new EFI changes
Date: Tue, 11 Feb 2014 16:19:03 -0600
Message-ID: <20140211221903.GG27648@sgi.com>
References: <20140128225905.GN815@pd.tnic>
 <20140128234036.GB18196@sgi.com>
 <20140129141822.GC24887@pd.tnic>
 <20140130221950.GJ3105@sgi.com>
 <52EAD0F2.7090101@zytor.com>
 <20140131100722.GA21873@pd.tnic>
 <20140131140220.GC22498@sgi.com>
 <20140131142318.GC21873@pd.tnic>
 <20140205214536.GT3034@sgi.com>
 <20140205231540.GB6364@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140205231540.GB6364-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 06, 2014 at 12:15:40AM +0100, Borislav Petkov wrote:
> On Wed, Feb 05, 2014 at 03:45:36PM -0600, Alex Thorlton wrote:
> > While working on an answer to this question, I ran across another issue
> > on some newer hardware, that looks like it's definitely related to this
> > problem, and might be the root cause.
> > 
> > When booting on a UV2 we die in efi_enter_virtual_mode:
> > 
> > BUG: unable to handle kernel paging request at 0000008f7e848020
> > IP: [<000000007dadb6a9>] 0x7dadb6a8
> > PGD 0
> 
> That looks very much like this other issue we're debugging right now:

Have there been any developments on this since last week, Boris?  Just
trying to make sure that we stay in the loop on this issue.

Let me know if there's anything else we can do from our end to help
expedite the process.  I'm always available to test new ideas.

Thanks!

- Alex
