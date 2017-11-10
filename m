From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Fri, 10 Nov 2017 02:46:41 +0100
Message-ID: <20171110014641.GO22894@wotan.suse.de>
References: <1509660086.3416.15.camel@linux.vnet.ibm.com>
 <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <14219.1509660259@warthog.procyon.org.uk>
 <1509660641.3416.24.camel@linux.vnet.ibm.com>
 <20171107230700.GJ22894@wotan.suse.de>
 <20171108061551.GD7859@linaro.org>
 <20171108194626.GQ22894@wotan.suse.de>
 <20171109014841.GF7859@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171109014841.GF7859-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jan Blunck <jblunck-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Marcus Meissner <meissner-l3A5Bk7waGM@public.gmane.org>, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 09, 2017 at 10:48:43AM +0900, AKASHI, Takahiro wrote:
> On Wed, Nov 08, 2017 at 08:46:26PM +0100, Luis R. Rodriguez wrote:
> > But perhaps I'm not understanding the issue well, let me know.
> 
> My point is quite simple:
> my_deviceA_init() {
>         err = request_firmware(&fw, "deviceA"); <--- (a)
>         if (err)
>                 goto err_request;
> 
>         err = verify_firmware(fw);  <--- (b)
>         if (err)
>                 goto err_verify;
> 
>         load_fw_to_deviceA(fw);     <--- (c)
>         ...
> }
> 
> As legacy device drivers does not have (b), there is no chance to
> prevent loading a firmware at (c) for locked-down kernel.

Ah, I think your example requires another piece of code to make it clearer.
Here is an example legacy driver:

my_legacy_deviceB_init() {
        err = request_firmware(&fw, "deviceB"); <--- (a)
        if (err)
                goto err_request;

        load_fw_to_deviceA(fw);     <--- (c)
        ...
}

There is no verify_firmware() call here, and as such the approach Linus
suggested a while ago cannot possibly fail on a "locked down kernel", unless
*very* legacy API call gets a verify_firmware() sprinkled.

One sensible thing to say here is then that all request_firmware() calls should
just fail on a "locked down kernel", however if this were true then even calls
which *did* issue a subsequent verify_firmware() would fail earlier therefore
making verify_firmware() pointless on new drivers.

Is that what you meant?

A long time ago we discussed similar default mechanisms, so its worth
re-iterating conclusions done before. The only difference with our current
discussion is that the latest proposed mechanism by Linus for firmware signing
was to consider a verify_firmware() so we can upkeep a functional API approach
to adding support for firmware signing.

What you are asking is what are default mechanism should be, and how do we
*ensure* this works using the functional API approach. We had ironed out
what the default mechanism should have been a while ago, not so much the
later as the firmware API has been in a state of flux. I'll provide pointers
to discussions around the default policy so that none of this is lost and
so that how we end up doing things is well understood later. We can try
to also hash out how to make this work then.

David Woodhouse has long recommended that a 'defult key' should only be last
resort [0], on that same email he also had suggested that since we could end up
supporting different signing schemes it may be best to support cryptographic
requirements (cert identifier or hash) from the start. James Bottomley has
recommended that the default behaviour can only be left up to "system policy".

A "system policy" is exactly what "kernel lockdown" is. David's email contained
a man page which stipulated that the policy that this type of system would follow
*is* to reject unsigned firmware. He and others may want to review if they indeed
wanted to follow this path in lieu of this email.

Even if one is not using a "kernel lockdown" system policy, we can consider the
old schemes discussed for firmware singing. In 2015 I first proposed a simple
signing scheme firmware signing which mimics the Linux module signing scheme
[2].  The issues with "purpose of a key" was well hashed out (a firmware key
should only work for firmware and only for the firmware it was designed for,
etc) and later iterations considered this thanks to Andy.

In this scheme, the default system policy depended on what kernel configuration
option your system had been built with, and matching the module signing scheme
we had:

	o CONFIG_FIRMWARE_SIG - "Firmware signature verification"
	o CONFIG_FIRMWARE_SIG_FORCE - "Require all firmware to be validly signed"

Everything about signing was done automatically behind the schemes for us, just
as with module signing.

If CONFIG_FIRMWARE_SIG_FORCE was *not* enabled, we'd grant unsigned firmwares
to be loaded, we'd just pr_warn() about them. Note that contrary to module
signing, firmware signing could not taint for technical reasons I listed on my
follow up patches after New Mexico Linux Plumbers [3]. Its worth re-iterating
so its not lost.

add_taint_module() is currently not exported, that can be fixed easily, but
also, the old firmware API currently does not associate the caller module in the
code, so we have a few options as to how to taint a kernel with unsigned firmware,
which I listed but I'll list here again:

  1) Extend the firmware_class driver API to require the correct module to
     always be set.

  2) Use add_taint_module() with the firmware_class module for the two
     synchrounous APIs, while using the right module for the async call.

  3) Use the firmware_class module for all 3 API calls when using
     add_taint_module()

  4) Skip tainting the kernel for unsigned firmware files

I went with 1) and 4) on that iteration of patches, with 1) only being done for
newer API calls. After this I stopped focusing on the firmware signing effort
as I first had to fix and clean up the firmware API in order to evolve it in a
more sane way for firmware signing later.

The "system policy" then was defined by kconfig. As per discussions it would
seem that some folks had issue with having a say the Linux Foundation being a
CA and say Kyle signing firmware would be kosher. In particular Alan Cox had
stated "A generic linux-firmware owned key would be both a horrendously
inviting attack target, and a single point of failure" [4].

Even if a default key is not used, old drivers may still desire to specify
a hash on an allowed firmware, and maybe that would suffice certain system
policies, however that is still a driver change, and an API call change, so
default policies for legacy drivers would still need to be considered when
evaluating and defining "system policies".

Andy has some work in progress worth evaluating for which could load a hash of
in-tree firmware into the kernel [5].

A system policy for "Kernel lockdown" may be compatible with the old approach
I had taken, its unclear and for that I'd ask David and others for feedback.

[0] https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2015-July/001945.html
[1] https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2015-July/001961.html
[2] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=fw-signing-v2-20150513
[3] https://lkml.kernel.org/r/1431541436-17007-1-git-send-email-mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org
[4] https://lkml.kernel.org/r/20150526180813.0ba1b5f5-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
[5] https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=intree_module_hashes

> If you allow me to bring in yet another function, say
> request_firmware_signable(), which should be used in place of (a)
> for all verification-aware drivers, that would be fine.

Right, so you're suggesting that if we instead had firmware singing
implemented as a new call, that supporting different policies would be
not just much easier, but possible.

I see your point and indeed its unclear to me at this time how to make
verify_firmware() work for legacy drivers with a system policy that is
a strict "kernel lockdown" policy which rejects unsigned firmware.

The obvious alternative, which I had suggested in my first iteration of patches
was to do the signature check for every call underneath the hood for *all*
callers depending on a Kconfig symbols, just as we deal with module signing,
but that has the limitations listed above about taint and also requiring
a default key for legacy drivers. Even though some folks may have issues with
a default firmware key, it could solve that.

That would load foo.bin. and its signature file, say foo.bin.p7s or
foo.bin.sign, or whatever. So it could check a signature if one is required
(say kernel lock down system policy) and just fail.

> In this case, all the invocation of request_firmware() in legacy code
> could be forced to fail in locked-down kernel.

That's also another option and its worth to hash out.

Since we got into this because I noted I have given into the functional API
design approach I think its worth it to say a bit more about that in comparison
to the data driven API I had proposed a while ago and also a bit about LSMs.

If it can work (its unclear it seems yet), in *this** particular case I think
it can make some sense to ask of something like a new verify_firmware() call
for this feature, given it may imply to do a good amount of work, in this case
fetch a signature file and verify it.

It'd be kind of silly to add tons of _signable() variations, so provided we're
OK in a verify_firmware() call to load the signature *after*, I see no issue
here.

That said, long term the functional API approach still may require adding
variations for other minor features but which require less amount of work
and for which I think then I think its reasonable to say that a "radical
functional API" approach just makes no sense.

For example, today we have request_firmware() for sync and
request_firmware_direct() when we wish to make it explicit sync request is
optional. But we have no equivalent optional semantics for async calls, we may
need this in the future, and sprinkling a postfix just for that seems rather
silly to me, specially when the only difference is just a simple flag check. By
contrast a verify_firmware() call can do much more work, and as such it seems
fair to argue for it.

The reason I had given up with the data driven API was that it was also radical,
I had suggested only two API calls, a sync and an async call, and left one huge
data structure to enable to modify behaviour in any possible way. This is just
as radical.

Mandating a new API call per *any* new feature is just stupid as requiring a
full blown data structure for any conceivable feature for an API.

So a "radical functional API" design approach is just as crazy as a
   a "radical data driven API" design approach.

A middle ground is sensible.

The optional mechanism is one which clearly should just be a flag, and so
I'll be first fixing the firmware API flag mess.

Firmware signing however requires a different possible set of requirements so
depending on what is agreed upon for a default system policy for legacy drivers,
it may or may not make sense for a new separate API call.

Lastly, long ago it was discussed that how the Linux kernel does module
signing really should be an LSM, but back in the day we didn't have stackable
LSMs, so this was not possible. Since we do now support stackable LSMs,
moving module signing to an LSM is in theory possible, and how we handle
firmware signing could also be an LSM. This way the approach you take to
firmware signing is more tied down to a form of security system policy
rather than some random kernel config option.

> But I think that "signable" should be allowed to be combined with other
> features of request_firmware variants like _(no)wait or _direct.

Let's first hash out the default policy allowed and how it can work with verify_firmware()
or if we need to abandon that idea.

  Luis
