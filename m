From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi/capsule: Make efi_capsule_pending() lockless
Date: Tue, 3 May 2016 15:12:01 +0100
Message-ID: <20160503141201.GW2839@codeblueprint.co.uk>
References: <1462054407-9735-1-git-send-email-matt@codeblueprint.co.uk>
 <20160503090229.GC27540@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160503090229.GC27540-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 03 May, at 11:02:29AM, Borislav Petkov wrote:
> On Sat, Apr 30, 2016 at 11:13:27PM +0100, Matt Fleming wrote:
> > Taking a mutex in the reboot path is bogus because we cannot sleep
> > with interrupts disabled, such as when rebooting due to panic(),
> > 
> >  [   18.069005] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:97
> >  [   18.071639] in_atomic(): 0, irqs_disabled(): 1, pid: 7, name: rcu_sched
> >  [   18.085940] Call Trace:
> >  [   18.086911]  [<ffffffff8142e53a>] dump_stack+0x63/0x89
> >  [   18.088260]  [<ffffffff810a1048>] ___might_sleep+0xd8/0x120
> >  [   18.089860]  [<ffffffff810a10d9>] __might_sleep+0x49/0x80
> >  [   18.091272]  [<ffffffff818f5110>] mutex_lock+0x20/0x50
> >  [   18.092636]  [<ffffffff81771edd>] efi_capsule_pending+0x1d/0x60
> >  [   18.094272]  [<ffffffff8104e749>] native_machine_emergency_restart+0x59/0x280
> >  [   18.095975]  [<ffffffff8104e5d9>] machine_emergency_restart+0x19/0x20
> >  [   18.097685]  [<ffffffff8109d4b8>] emergency_restart+0x18/0x20
> >  [   18.099303]  [<ffffffff81172d6d>] panic+0x1ba/0x217
> 
> Please remove all stuff in [] and the offsets and leave only the call
> trace with the function names. The numbers are useless and only get in
> the way.
 
OK.

> > In this case all other CPUs will have been stopped by the time we
> > execute the platform reboot code, so 'capsule_pending' cannot change
> > under our feet. We wouldn't care even if it could since we cannot wait
> > for it complete.
> > 
> > Also, instead of relying on the external 'system_state' variable just
> > use a reboot notifier, so we can set 'stop_capsules' while holding
> > 'capsule_mutex', thereby avoiding a race where system_state is updated
> > while we're in the middle of efi_capsule_update_locked() (since CPUs
> > won't have been stopped at that point).
> 
> So I'm wondering: why can't we push all that logic higher up the API
> chain, say in efi_capsule_open() or efi_capsule_write() or so?
> 
> I mean, userspace can either reboot *or* update capsules but both? Both
> would be kinda nasty, like, 2 admins doing that stuff in parallel...
 
We can find ourselves in the reboot code even if the admin has not
executed the reboot command. The trace above shows we entered because
the kernel panic()'d and it was booted with panic=-1.

Additionally, if you grep for kernel_restart() and you'll see other
ways we can be rebooted outside of the admin's control.
 
> > 
> > Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> > Cc: Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Cc: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
> > Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
> > Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> > ---
> >  drivers/firmware/efi/capsule.c | 36 ++++++++++++++++++++++++++----------
> >  1 file changed, 26 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
> > index 0de55944ac0b..4703dc9b8fbd 100644
> > --- a/drivers/firmware/efi/capsule.c
> > +++ b/drivers/firmware/efi/capsule.c
> > @@ -22,11 +22,12 @@ typedef struct {
> >  } efi_capsule_block_desc_t;
> >  
> >  static bool capsule_pending;
> > +static bool stop_capsules;
> >  static int efi_reset_type = -1;
> >  
> >  /*
> >   * capsule_mutex serialises access to both capsule_pending and
> > - * efi_reset_type.
> > + * efi_reset_type and stop_capsules.
> >   */
> >  static DEFINE_MUTEX(capsule_mutex);
> >  
> > @@ -50,18 +51,13 @@ static DEFINE_MUTEX(capsule_mutex);
> >   */
> >  bool efi_capsule_pending(int *reset_type)
> >  {
> > -	bool rv = false;
> > -
> > -	mutex_lock(&capsule_mutex);
> >  	if (!capsule_pending)
> > -		goto out;
> > +		return false;
> >  
> >  	if (reset_type)
> >  		*reset_type = efi_reset_type;
> > -	rv = true;
> > -out:
> > -	mutex_unlock(&capsule_mutex);
> > -	return rv;
> > +
> > +	return true;
> >  }
> >  
> >  /*
> > @@ -176,7 +172,7 @@ efi_capsule_update_locked(efi_capsule_header_t *capsule,
> >  	 * whether to force an EFI reboot), and we're racing against
> >  	 * that call. Abort in that case.
> >  	 */
> > -	if (unlikely(system_state == SYSTEM_RESTART)) {
> > +	if (unlikely(stop_capsules)) {
> >  		pr_warn("Capsule update raced with reboot, aborting.\n");
> >  		return -EINVAL;
> >  	}
> 
> ... also, what happens if stop_capsules gets set here
> 

It can't, capsule_mutex prevents that.

> <---
> 
> after the check? We will continue trying to update but the box is
> already rebooting too. I think to solve this here properly, you'd need
> to be able to hold off reboot temporarily until you either update the
> capsule successfully or fail.
> 
> But that sounds nasty.
 
Right. You could find yourself in this situation if you're in the
middle of a capsule update and the box panics and reboots. Like you
said, there's really not much you can do there to ensure the update
completes. Your best option is to just not block and hang the machine.

> So the first case where the capsule update is started after reboot is
> easy: the reboot notifier disables capsules update, done.
 
Yep.

> The second one where a reboot comes *after* the capsule update has
> started is a bit tricky. My current thinking is to maybe disable
> virt_efi_update_capsule() with the reboot notifier. But we'd still need
> some sort of a synchronization with reboot there too, if we want to be
> absolutely clean.
> 
> Something like make both the reboot notifier and
> virt_efi_update_capsule() grab efi_runtime_lock or so which
> virt_efi_update_capsule() already does...
> 
> I could very well be missing something though...

Note that in the panic() -> emergency_restart() case the reboot
notifiers are not called at all.
