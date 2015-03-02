From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Mon, 2 Mar 2015 12:29:55 +0000
Message-ID: <20150302122955.GB24476@codeblueprint.co.uk>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AD9CA@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B8AD9CA-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 02 Mar, at 10:59:00AM, Kweh Hock Leong wrote:
> > -----Original Message-----
> > From: Borislav Petkov [mailto:bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org]
> > Sent: Wednesday, February 25, 2015 8:49 PM
> > 
> > On Wed, Feb 25, 2015 at 12:38:20PM +0000, Kweh, Hock Leong wrote:
> > > The reason we use this interface for efi capsule is that efi capsule
> > > support multi binaries to be uploaded and each binary file name
> > > can be different.
> > 
> > So you can write the file path to a second file and reload then, once
> > per file.
> 
> Thanks for the suggestion. Did some exploration on this approach and
> would like to continue the discussion together with this suggested design.
> 
> Ideal condition:
> - one file note is enough for load binary and status return (capsule_load)
> - load steps would be as simple as just:
>    echo [binary file name] > capsule_load
> - status return in the same command action. If failed, the echo will fail
>    with the failing status code.
> 
> Trade off:
> - does not have the run time flexibility to load any firmware binaries at
>    different different path as firmware class  only support one custom
>    path inputted during boot time/load time. Unless to add new export
>    function for firmware class.

Could you elaborate here? I don't understand this point.

> - if any typo on user level or file path not found, firmware class falls back
>    to user helper interface. User is required to open another terminal to
>    performs:
>    -> echo 1 > loading
>    -> cat capsule.bin > data
>    -> echo 0 > loading
>    Or wait for timeout.

Not if you use request_firmware_direct(), right?
request_firmware_direct() explicitly does not invoke the user helper.

> - User has the capability to configure the firmware_class time out value.
>    If the infinite value is set, the only method to break the infinite waiting
>    by manually perform "echo -1 > loading" on the other terminal.
 
I'm not sure this is a problem if we use request_firmware_direct().

> Are you guys okay with these trade off?
> Or you guys still okay with the previous 2 design idea?
 
I quite like the design that Borislav is proposing. Things become a lot
simpler when we stop using request_firmware_nowait().

The next question is whether we want to batch passing capsules to the
firmware. The UpdateCapsule() EFI runtime service allows you to chain
capsule blobs together and pass a scatter-gather list.

If we do want to batch uploading then we need the equivalent of the
'reload' file from the microcode loader to signal to the kernel that the
userland process has finished uploading capsules, and the kernel can now
send them to the firmware as one chunk.

Also, Andy previously raised the point about multiple userland processes
passing capsules to the firmware simultaneously and the races that
occur, so we'd need a way to make that atomic.

I'd much prefer to send one capsule at a time to the firmware, because
it just makes this whole thing simpler.

Wilson, I'm really looking for your input here with how capsule
uploading works on Quark. If we can just repeatedly call UpdateCapsule()
with one capsule file at a time, that's fine. If we absolutely must
bundle multiple capsule files together then we probably need to provide
some atomicity.

Thoughts?

> > Alternatively, you can combine all the files into a cpio archive like
> > we do with the microcode loader too, and let the kernel parse the cpio
> > archive.
> 
> I believe this will make the implementation complicated compare to above.

Agreed. The capsule files we're sending to the firmware (via this
interface) already contain all the information we need to stitch
multiple binaries together - there's really no reason to bundle things
any further.

-- 
Matt Fleming, Intel Open Source Technology Center
