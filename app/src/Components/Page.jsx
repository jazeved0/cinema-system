import React from "react";
import { isDefined } from "Utility";

import Helmet from "react-helmet";

const siteTitle = "Cinema System";
const description =
  `This website is the result of a semester-long group project for CS 4400: ` +
  `Intro Database Systems with Professor Mark Moss. In this project, we have` +
  ` developed a movie system using relational database concepts and developed` +
  ` an application layer/frontend with Python Flask and React.`;
const card = "/card.png"
export default function Page(props) {
  const { title, children } = props;
  const fullTitle = isDefined(title) ? `${title} | ${siteTitle}` : siteTitle;
  return (
    <>
      <Helmet
        title={fullTitle}
        meta={[
          {
            property: "og:title",
            content: fullTitle
          },
          {
            name: "description",
            content: description
          },
          {
            property: "og:description",
            value: description
          },
          {
            property: "og:site_name",
            value: siteTitle
          },
          {
            property: "og:image",
            value: card
          }
        ]}
      />
      {children}
    </>
  );
}
Page.displayName = "Page";
