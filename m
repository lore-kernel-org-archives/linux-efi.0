From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC v2 0/2] Early use of boot service memory
Date: Fri, 22 Nov 2013 01:16:13 +0000
Message-ID: <20131122011613.GA1039@srcf.ucam.org>
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
 <20131121230744.GA31592@srcf.ucam.org>
 <20131121233104.GF1106@anatevka.fc.hp.com>
 <20131121233831.GB32121@srcf.ucam.org>
 <20131122010515.GG1106@anatevka.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131122010515.GG1106@anatevka.fc.hp.com>
Sender: linux-doc-owner@vger.kernel.org
To: jerry.hoemann@hp.com
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org, akpm@linux-foundation.org, bp@suse.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, penberg@kernel.org, mingo.kernel.org@gmail.com, vgoyal@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 21, 2013 at 06:05:15PM -0700, jerry.hoemann@hp.com wrote:
> On Thu, Nov 21, 2013 at 11:38:31PM +0000, Matthew Garrett wrote:
> > Hm. If the problem is fragmentation, then yeah, I can imagine this 
> > causing problems. In that case we could take a two-pass approach - find 
> > a gap that *will* be big enough, reserve everything that isn't currently 
> > reserved, and then reserve the rest after ExitBootServices()?
> 
> 
> Matthew,
> 
> Did you really mean EnterVirtualMode (not ExitBootServices?)

I think I actually meant SetVirtualAddressMap() :)

> In one of your earlier emails you mentioned the issue is that linux makes
> regions NX.  That would cause problems if FW tried to execute a region
> we just reserved.  Unfortunately, i'm not seeing where the kernel is
> doing this for crash kernel memory.  Assuming it is making it NX, can
> we defer that part?  Or if its not, do we have a problem w/ crash kernel
> reservation at all?

I don't think we explicitly do that at any point for crash kernel 
regions. The boot services regions get toggled by efi_set_executable().

> Interesting questions, but as I don't have access to a system that has
> the firmware defects encountered when efi_reserve_boot_services, it makes
> it difficult to test that i don't break them.  Hence, the appealing nature
> of quirks.  Don't have to worry about breaking other platforms as they
> continue to operate same as before.

Yeah. The problem is that some users may want kdump while still having 
broken firmware, so a solution that works for them is much more 
appealing than one which involves manually maintaining a list of 
verified systems...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
