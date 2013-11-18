From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 1/3 v2] Add function get_bootparam
Date: Mon, 18 Nov 2013 13:29:49 +0800
Message-ID: <20131118052949.GA14532@dhcp-16-126.nay.redhat.com>
References: <1384219658.1847.84.camel@misato.fc.hp.com>
 <52819E71.70201@zytor.com> <20131112075831.GA6213@kroah.com>
 <20131112080854.GD6999@dhcp-16-126.nay.redhat.com>
 <20131112083012.GB7708@kroah.com> <5281F6D5.4090700@zytor.com>
 <20131112095114.GA20100@kroah.com>
 <20131113005032.GB5069@dhcp-16-126.nay.redhat.com>
 <20131118022234.GD4025@dhcp-16-126.nay.redhat.com>
 <52898982.3020200@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52898982.3020200-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/17/13 at 07:29pm, H. Peter Anvin wrote:
> On 11/17/2013 06:22 PM, Dave Young wrote:
> > On 11/13/13 at 08:50am, Dave Young wrote:
> >> On 11/12/13 at 06:51pm, Greg KH wrote:
> >>> On Tue, Nov 12, 2013 at 01:37:25AM -0800, H. Peter Anvin wrote:
> >>>> On 11/12/2013 12:30 AM, Greg KH wrote:
> >>>>>
> >>>>> And these binary data blobs are a "standard" somewhere, and will not
> >>>>> change per kernel version change?
> >>>>>
> >>>>> If so, that structure is fine with me.
> >>>>>
> >>>>
> >>>> Correct.  The structure is documented in Documentation/x86/boot.txt, and
> >>>> has been largely invariant (but extended) since the beginning of Linux.
> >>>>  It has sometimes taken some serious work to keep it that way.
> >>>
> >>> Ok, then use the binary sysfs file interface for these blobs, and
> >>> everyone will be happy.
> >>
> >> Since we got an agreement I will move them to sysfs in next version.
> > 
> > I have created one patch for the sysfs part this weekend, bug I'm hesitating to
> > remove the debugfs part because currently there's already user, I tend to
> > keep them in debugfs for now.
> > 
> > What do you think, Peter?
> > 
> 
> Yes, it makes sense to keep them for compatibility, at least for now.
> What is the specific user that already exists?

kexec-tools is using it to setup hardware_subarch..

--
Thanks
Dave
