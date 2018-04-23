From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: random.c regression on arm64 EFI systems
Date: Mon, 23 Apr 2018 09:11:19 +0200
Message-ID: <CAKv+Gu_U_JWFD5J=fnibk8783G2t9sUqVwm+5HgkzUG9k==KZA@mail.gmail.com>
References: <CAKv+Gu9yKSF=XdHFD4bQEZar+RQxtPjR+a6NrSXCTdu_j6+iaw@mail.gmail.com>
 <20180422145036.GA5554@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180422145036.GA5554@thunk.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-efi@vger.kernel.org, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Jann Horn <jannh@google.com>
List-Id: linux-efi@vger.kernel.org

On 22 April 2018 at 16:50, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Sun, Apr 22, 2018 at 01:32:15PM +0200, Ard Biesheuvel wrote:
>> Hello all,
>>
>> Today's pull of random.c changes caused a regression on arm64 UEFI
>> systems that invoke EFI_RNG_PROTOCOL to obtain strong entropy from the
>> platform. (arm64 does not have an architected instruction a la RDRAND)
>
> So this isn't exactly a regression.  Triggering these warning messages
> after "fast init done" and before "crng_init_done" is working as
> intended as far the changes are concerned:
>

That may be true, but a previously working system now produces ominous
warning messages, so from a user pov, something did get broken.

>>   random: fast init done
>>   ...
>>   random: get_random_bytes called from start_kernel+0xb4/0x48c with crng_init=0
>>   random: systemd: uninitialized urandom read (16 bytes read)
>>   ...
>>   random: crng init done
>
>> The current EFI code uses add_device_randomness() to pass the firmware
>> provided strong random seed to the kernel, for lack of a more
>> appropriate interface (at the time, at least).
>
> The original philosophical design is that we don't trust *any*
> hardware-generated randomness.  This includes RDRAND.  The reason for
> this is that we didn't want to make any assertions that some hardware
> was definitely secure.  If you're in the US, you might not trust
> hardware built in China --- maybe the MSS has inserted a backdoor into
> the SOC built in a manufacturing line in China.  If you're in China,
> you might not trust RDRAND or a hardware RNG since you never know if
> the NSA has gotten to Intel or IBM or has had the Tailored Access
> Operations team intercept hardware being shipped from point A to point
> B to subvert the hardware in some way.
>
> This used to apply even to the hardware RNG's as well, for similar
> reasons.  Users had to explicitly set rng_core's default_quality to a
> non-zero value, or explicitly set the actual hardware random number
> generator's quality field to a non-zero value.  There has been _one_
> example to this rule which is for virtio_rng.  The assumption is that
> if the Host is not trustworthy, you're screwed anyway, and VM's badly
> need real entropy.
>
>> I tried to switch to add_hwgenerator_randomness(), which seems more
>> appropriate, but it appears to me that it is impossible to get the
>> kernel entropy pool into the fully initialized state (crng_init=2)
>> using that without some dodgy tricks.
>
> It's possible, but you have to set the quality to some non-zero
> value.  See how it is done with drivers/char/hw_random/virtio-rng.c.
>

The EFI code does not expose a hw random number generator that a
driver can attach to. We only generate an initial seed when executing
the stub in the UEFI context (where it has access to all boot time
protocols) and pass this seed to the kernel proper using a EFI
configuration table. This seed could be of arbitrary size, and it
would be nice if we could figure out a way where incorporating this
seed would fully initialize the kernel entropy pool.

> The real question is the philosophical question.  Are we really sure
> we want to assert that we *really* trust the UEFI RNG implementation,
> for all UEFI implemntations?  I suppose you could make the claim that
> at least with Intel implemntations, and completely incompetent Intel
> Management Engine implementations, if you don't trust Intel (either in
> the competence of their firmware engineers or their ethics about
> adding NSA backdoors), you're toast anyway.  :-)
>
> I was hoping though that ARM64 would be making a stronger statements
> the easy/likelihood of backdoors in the mangemnt engine, at least as
> far as the actual ARM64 *CPU*, and that the real risk would be come
> from a particular motherboard's UEFI implementation.
>
> So we could relax our standards, and make claims that we trust
> UEFI_RNG_PROTOCOL.
>

In the x86 world, UEFI == proprietary == evil backdoors, but in the
ARM ecosystem, we are trying very hard to assert our influence to open
up firmware implementations. We also contributed a UEFI driver for the
ChaosKey, which should be usable on any UEFI implementation that
supports USB (which should be the majority of them, given that it is
needed for keyboard support).

So the assumption that the platform is evil does not always hold.

> Alternatively, maybe we should be pushing get the kernel and systemd
> to avoid trying to use random numbers, or at least strong random
> numbers super-early in the boot process.  If systemd is just using
> getrandom() for something silly, like UUID's, perhaps we change it to
> use a userspace psuedo-random number, or maybe we add a flag to
> getrandom(2), GRND_BEST_EFFORTS or GRND_PSUEDORANDOM, which doesn't
> trigger the warning.
>

systemd could perhaps be taught to use rand(), but start_kernel()
invokes get_random_bytes() for the initial stack canary value, so I
suppose we do need some true entropy early on.
