From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Date: Thu, 21 Mar 2013 09:43:48 -0400
Message-ID: <20130321134348.GA3934@redhat.com>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
 <alpine.LRH.2.02.1303191542200.30973@tundra.namei.org>
 <1363797717.2580.10.camel@falcor1.watson.ibm.com>
 <1363798166.2553.29.camel@x230.sbx07502.somerma.wayport.net>
 <1363802506.2580.55.camel@falcor1.watson.ibm.com>
 <1363803158.2553.33.camel@x230.sbx07502.somerma.wayport.net>
 <1363806968.2580.86.camel@falcor1.watson.ibm.com>
 <1363811856.2553.37.camel@x230.sbx07502.somerma.wayport.net>
 <1363813877.2580.120.camel@falcor1.watson.ibm.com>
 <1363814289.2553.41.camel@x230.sbx07502.somerma.wayport.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1363814289.2553.41.camel-tCUS0Eywp2Pehftex57rkxo58HMYffqeLoYNBG0abjxeoWH0uzbU5w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 20, 2013 at 09:18:10PM +0000, Matthew Garrett wrote:
> On Wed, 2013-03-20 at 17:11 -0400, Mimi Zohar wrote:
> > On Wed, 2013-03-20 at 20:37 +0000, Matthew Garrett wrote:
> > > Right, that'd be the rough idea. Any further runtime policy updates
> > > would presumably need to be signed with a trusted key.
> > 
> > I'm really sorry to belabor this point, but can kexec rely on an LSM
> > label to identify a specific file, out of all the files being executed,
> > in a secure boot environment?  The SELinux integrity rule for kexec
> > would then look something like,
> >
> > appraise func=BPRM_CHECK obj_type=kdump_exec_t appraise_type=imasig
> 
> It would certainly be possible to configure a system such that this was
> true (assuming support for signed initramfs and restricted policy
> loading), and anyone wanting to ensure that kexec only loaded trusted
> binaries would have to ensure that their system was appropriately
> configured. Having some mechanism to then give the kexec binary
> CAP_MODIFY_KERNEL would avoid needing an extra kexec entry point.

Giving CAP_MODIFY_KERNEL to processess upon signature verification
will simplify things a bit.

Only thing is that signature verification alone is not sufficient. We
also need to make sure after signature verification executable can
not be modified in memory in any way. So that means atleast couple of
things.

- Process code/data should not be swapped out. Otherwise it can possibly
  be written by unsigned priviliged processes and then faulted in back.

- Because priviliged unsigned processes can bypass file system and
  directly write to disk, do not cache appraisal results. So create a
  way in IMA rules to not cache the results.

I think memory locking part is little tricky as what part of files are
to be locked will depend on the binary loader (and not IMA). May be IMA
can set a flag somewhere which gives an hint to binary loader that lock
down file. Once the file has been locked down, binary loader should
set some flag too and call security hook. This flag will be a hint to IMA
that file has been locked down, another appraisal happens and if
it passes successfuly, then IMA can give CAP_MODIFY_KERNEL capability
to the process.

Another small nit is appraise_type=imasig. Given the fact that there
can be many formats of digital signature, we might have to make it
more fine grained to be able to specify a particular kind of digital
signature and not every possible digital signature supported. 

Assuming all this works, I can look into how /sbin/kexec can call into
kernel to verify integrity of bzImage before it is loaded. Not sure one
needs to very PE/COFF signature or bzImage will be re-signed using IMA
and one needs to call into IMA. I think here also we will have to first
lock down file in memory, make sure nobody can open file for writes,
and then do signature verification. 

Thanks
Vivek
