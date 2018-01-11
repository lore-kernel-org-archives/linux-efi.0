From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 08/30] kexec_file: Restrict at runtime if the kernel is locked down
Date: Thu, 11 Jan 2018 12:47:57 +0000
Message-ID: <13005.1515674877@warthog.procyon.org.uk>
References: <12880.1515674600@warthog.procyon.org.uk> <20180111115915.dejachty3l7fwpmf@dwarf.suse.cz> <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk> <151024869793.28329.4817577607302613028.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <12880.1515674600@warthog.procyon.org.uk>
Content-ID: <13004.1515674877.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Jiri Bohac <jbohac@suse.cz>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, jforbes@redhat.com, Chun-Yi Lee <joeyli.kernel@gmail.com>
List-Id: linux-efi@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > I don't like the idea that the lockdown (which is a runtime
> > thing) requires a compile time option (KEXEC_VERIFY_SIG) that
> > forces the verification even when the kernel is then not locked
> > down at runtime.
> 
> It doesn't.  The EPERM only triggers if:
> 
>  (1) File signatures aren't mandatory (ie. CONFIG_KEXEC_VERIFY_SIG) is not
>      set, and
> 
>  (2) you're not using IMA appraisal to validate the file contents, and
> 
>  (3) lockdown mode is enabled.
> 
> If file signatures are mandatory or IMA appraisal is in use, then the lockdown
> state doesn't need to be checked.

Having said that, I do see your point, I think.  We should still let through
validly signed images, even if signatures aren't mandatory in lockdown mode.

David
