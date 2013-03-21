From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Date: Thu, 21 Mar 2013 11:52:20 -0400
Message-ID: <20130321155220.GL3934@redhat.com>
References: <1363797717.2580.10.camel@falcor1.watson.ibm.com>
 <1363798166.2553.29.camel@x230.sbx07502.somerma.wayport.net>
 <1363802506.2580.55.camel@falcor1.watson.ibm.com>
 <1363803158.2553.33.camel@x230.sbx07502.somerma.wayport.net>
 <1363806968.2580.86.camel@falcor1.watson.ibm.com>
 <1363811856.2553.37.camel@x230.sbx07502.somerma.wayport.net>
 <1363813877.2580.120.camel@falcor1.watson.ibm.com>
 <1363814289.2553.41.camel@x230.sbx07502.somerma.wayport.net>
 <20130321134348.GA3934@redhat.com>
 <20130321153725.GA3656@austin.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130321153725.GA3656-anj0Drq5vpzx6HRWoRZK3AC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 21, 2013 at 10:37:25AM -0500, Serge E. Hallyn wrote:
> Quoting Vivek Goyal (vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> ...
> > Giving CAP_MODIFY_KERNEL to processess upon signature verification
> > will simplify things a bit.
> > 
> > Only thing is that signature verification alone is not sufficient. We
> > also need to make sure after signature verification executable can
> > not be modified in memory in any way. So that means atleast couple of
> > things.
> 
> Also what about context?  If I construct a mounts namespace a certain
> way, can I trick this executable into loading an old singed bzImage that
> I had laying around?

We were thinking that /sbin/kexec will need to verify bzImage signature
before loading it. 

Key for verification is in kernel so idea was to take kernel's help
in verifying signature.

Not sure how exactly the interface should look like. 

- I was thinking may be process can mmap() the bzImage with MAP_LOCKED.
  We can create additional flag say MAP_VERIFY_SIG_POST, which tries
  to verify signature/integrity of mapped region of file after mapping and
  locking pages and mmap() fails if signature verification fails.

There have been suggestions about creating new system call altogether.

> 
> ISTM the only sane thing to do, if you're going down this road,
> is to have CAP_MODIFIY_KERNEL pulled from bounding set for everyone
> except a getty started by init on ttyS0.  Then log in on serial
> to update.  Or run a damon with CAP_MODIFIY_KERNEL which listens
> to a init_net_ns netlink socket for very basic instructions, like
> "find and install latest signed bzImage in /boot".  Then you can
> at least trust that /boot for that daemon is not faked.

daemon does not have the key and can't verify signature of signed
bzImage. Even if it had the key, it can't trust the crypto code for
signature verification as none of that is signed.

Thanks
Vivek
