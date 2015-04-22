From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Tue, 21 Apr 2015 19:20:28 -0700
Message-ID: <1429669228.2207.46.camel@HansenPartnership.com>
References: <1429004697-28320-3-git-send-email-hock.leong.kweh@intel.com>
	 <20150414140914.GE5989@kroah.com>
	 <F54AEECA5E2B9541821D670476DAE19C2B8D2AEA@PGSMSX102.gar.corp.intel.com>
	 <20150415131906.GC21491@kroah.com>
	 <F54AEECA5E2B9541821D670476DAE19C2B8D2E74@PGSMSX102.gar.corp.intel.com>
	 <20150417134924.GB19794@kroah.com>
	 <20150417143640.GB3671@codeblueprint.co.uk>
	 <F54AEECA5E2B9541821D670476DAE19C2C279176@PGSMSX101.gar.corp.intel.com>
	 <20150420144323.GA7261@kroah.com>
	 <F54AEECA5E2B9541821D670476DAE19C2CC11869@PGSMSX102.gar.corp.intel.com>
	 <20150421075620.GA11000@kroah.com>
	 <1429665679.2207.44.camel@HansenPartnership.com>
	 <CALCETrX9GZmWnfkm-CwKW-2mPvRbNcRaY6tUY=8e0THsPBKMcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrX9GZmWnfkm-CwKW-2mPvRbNcRaY6tUY=8e0THsPBKMcA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ming Lei <ming.lei@canonical.com>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2015-04-21 at 18:58 -0700, Andy Lutomirski wrote:
> On Tue, Apr 21, 2015 at 6:21 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > Andy, just on the misc device idea, what about triggering the capsule
> > update from close()?  In theory close returns an error code (not sure if
> > most tools actually check this, though).  That means we can do the write
> > in chunks but pass it in atomically on the close and cat will work
> > (provided it checks the return code of close).
> 
> I thought about this but IIRC cat doesn't check the return value from close.

It does in my copy (coreutils-8.23) :

      if (!STREQ (infile, "-") && close (input_desc) < 0)
        {
          error (0, errno, "%s", infile);
          ok = false;
        }
[...]
  if (have_read_stdin && close (STDIN_FILENO) < 0)
    error (EXIT_FAILURE, errno, _("closing standard input"));


James
