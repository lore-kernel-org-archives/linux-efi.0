Return-Path: <SRS0=gsoD=4O=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C74C4BA21
	for <linux-efi@archiver.kernel.org>; Wed, 26 Feb 2020 21:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE95D24656
	for <linux-efi@archiver.kernel.org>; Wed, 26 Feb 2020 21:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582753256;
	bh=8r66nlawNRi7viwGZT+CztqVRc+7mDG7RHklqp3gfNI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=VrZijNfO0zxKLJ6IujIbJO7M4iqNXiAbvR1Zbi2EqQvWKlu4pTY6coKzEDEwdwl9O
	 kCA/FTUkhpY31QHa7nVCv9M4M5nqDqWOFkId025uQ9K7kzpGoI2SYxFbrKkVyjtW+4
	 9La7KSy1eIHK4+dqhv3fAj5WsrcvDwO0WK8wnAck=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbgBZVkx (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 26 Feb 2020 16:40:53 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39254 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbgBZVkx (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 26 Feb 2020 16:40:53 -0500
Received: by mail-oi1-f196.google.com with SMTP id 18so1102921oij.6;
        Wed, 26 Feb 2020 13:40:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iHvJZXfaFsdBwQaJk2vv6saQQi9sRm0B88DNe3HWc6U=;
        b=O59y3k+amR+foCObRzCTtZXKHpg+4oSwKEjkMIDWoLrcE3S/PjnFKg+aR9nrTaZ2t2
         XUB8PDKaKdzVbGqKQnaw0tcpWSZKiIzWKJvm9aWt0a9vVnSedhbLqAAFWNc3BMRuCG1l
         DO8ccXrBJ4KeSMBkohe7ai3pPR2oX6ZFkJ9WNuzXnPZHQiD6+6YWAyw6KWAZFFxiLv1s
         JDjwW8qfRmjfwZp4mHphZk6R8uXw+AfZI2qUaoszONWmsNOLbOVdgaxG3A0nfqcJBC3/
         lcD63tseBWOJ1rJL9uFvr75pfFPqsJrqxnyp6lsl4XmE0DpVLPYiIhbjbM2uu1/XBy+Q
         kA5Q==
X-Gm-Message-State: APjAAAW1twytOomTMrOdnZoO0cUU/HxDzFPZsnIzVXa0Qpa0nReu29n0
        nTXLdngmPT/pIZgt5iMR7A==
X-Google-Smtp-Source: APXvYqxN4pJ97lfj17OYt1whimF+bYNAHeUpRu+ka34H+OLES7lZ4DVO98kdtzfHlvz+59DWiwBtAg==
X-Received: by 2002:aca:ddc2:: with SMTP id u185mr919432oig.24.1582753252516;
        Wed, 26 Feb 2020 13:40:52 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id q6sm1211721otn.73.2020.02.26.13.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 13:40:51 -0800 (PST)
Received: (nullmailer pid 8039 invoked by uid 1000);
        Wed, 26 Feb 2020 21:40:51 -0000
Date:   Wed, 26 Feb 2020 15:40:51 -0600
From:   Rob Herring <robh@kernel.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        kernel-team@android.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 4/5] of: property: Start using fw_devlink_get_flags()
Message-ID: <20200226214051.GA7980@bogus>
References: <20200222014038.180923-1-saravanak@google.com>
 <20200222014038.180923-5-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200222014038.180923-5-saravanak@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, 21 Feb 2020 17:40:37 -0800, Saravana Kannan wrote:
> The fw_devlink_get_flags() provides the right flags to use when creating
> mandatory device links derived from information provided by the
> firmware. So, use that.
> 
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> ---
>  drivers/of/property.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
